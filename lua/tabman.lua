local M = {}

local bufferid = -1
local winid = -1

local tabman = {}

function tabman.workspace_directory(tabid)
  local win = vim.api.nvim_tabpage_get_win(tabid)
  local cwd = ''
  -- @fixme faile to get cwd from winid
  -- https://github.com/neovim/neovim/issues/37638
  -- so need to change getcwd(win-id) to getcwd(win-id, tabnr)
  for nr, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if tab == tabid then
      cwd = vim.fn.getcwd(win, nr)
      break
    end
  end
  return vim.fn.fnamemodify(cwd, ':t')
end

function tabman.toggle()
  local cursor = vim.api.nvim_win_get_cursor(winid)
  local obj = tabman.objs[cursor[1]]
  if obj and obj.tabid then
    if tabman.expanded(obj.tabid) then
      vim.api.nvim_tabpage_set_var(obj.tabid, 'tabman_expanded', false)
    else
      vim.api.nvim_tabpage_set_var(obj.tabid, 'tabman_expanded', true)
    end
  end
  tabman.update_context()
end

function tabman.jump()
  local cursor = vim.api.nvim_win_get_cursor(winid)
  local obj = tabman.objs[cursor[1]]
  if obj then
    if obj.winid then
      vim.api.nvim_set_current_win(obj.winid)
    else
      vim.api.nvim_set_current_win(vim.api.nvim_tabpage_get_win(obj.tabid))
    end
  end
end

function tabman.close()
  local cursor = vim.api.nvim_win_get_cursor(winid)
  local obj = tabman.objs[cursor[1]]
  if obj and obj.tabid then
    -- seems there is no neovim api to close tabpage
    for idx, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
      if tabpage == obj.tabid then
        vim.cmd('tabclose ' .. idx)
        return
      end
    end
  end
end

---@return integer
local function init_buffer()
  local buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('buflisted', false, { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'tabman', { buf = buf })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'o', '', { callback = tabman.toggle })
  vim.api.nvim_buf_set_keymap(
    buf,
    'n',
    '<Cr>',
    '',
    { callback = tabman.jump }
  )
  vim.api.nvim_buf_set_keymap(buf, 'n', 'x', '', { callback = tabman.close })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', { callback = function()
    vim.cmd.close()
  end })
  return buf
end

function tabman.expanded(tabid)
  local ok, var =
    pcall(vim.api.nvim_tabpage_get_var, tabid, 'tabman_expanded')
  return ok and var
end

---@return integer
local function init_windows(buf)
  local win = vim.api.nvim_open_win(buf, true, {
    split = 'left',
    width = 30,
  })

  vim.api.nvim_set_option_value('number', false, { win = win })
  vim.api.nvim_set_option_value('relativenumber', false, { win = win })
  vim.api.nvim_set_option_value('winfixwidth', true, { win = win })
  vim.api.nvim_set_option_value('list', false, { win = win })
  vim.api.nvim_set_option_value('wrap', false, { win = win })
  vim.api.nvim_set_option_value('cursorline', false, { win = win })
  vim.api.nvim_set_option_value('spell', false, { win = win })

  return win
end

function tabman.update_context()
  local buflines = {}
  tabman.objs = {}
  for idx, tabid in ipairs(vim.api.nvim_list_tabpages()) do
    if tabman.expanded(tabid) then
      local line = '▼ '
      if idx == vim.fn.tabpagenr() then
        line = line .. '*Tab ' .. idx
      else
        line = line .. ' Tab ' .. idx
      end
      line = line .. ' ' .. tabman.workspace_directory(tabid)
      table.insert(buflines, line)
      table.insert(tabman.objs, { tabid = tabid })
      for _, win in
        ipairs(vim.tbl_filter(function(win)
          if tabman.filter then
            local f = tabman.filter(win)
            if f then
              return vim.api.nvim_win_get_config(win).focusable
            else
              return false
            end
          else
            return vim.api.nvim_win_get_config(win).focusable
          end
        end, vim.api.nvim_tabpage_list_wins(tabid)))
      do
        local buf = vim.api.nvim_win_get_buf(win)
        line = '  '
        if #vim.api.nvim_buf_get_name(buf) == 0 then
          line = line .. 'No Name'
          local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
          if #ft > 0 then
            line = line .. string.format(' (%s)', ft)
          end
        else
          line = line
            .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
        end
        table.insert(buflines, line)
        table.insert(tabman.objs, { tabid = tabid, winid = win })
      end
    else
      local line = '▷ '
      if idx == vim.fn.tabpagenr() then
        line = line .. '*Tab ' .. idx
      else
        line = line .. ' Tab ' .. idx
      end
      line = line .. ' ' .. tabman.workspace_directory(tabid)
      table.insert(buflines, line)
      table.insert(tabman.objs, { tabid = tabid })
    end
  end
  vim.api.nvim_set_option_value('modifiable', true, { buf = bufferid })
  vim.api.nvim_buf_set_lines(bufferid, 0, -1, false, buflines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = bufferid })
end

---@class tabman.OpenOpts
---@field filter? fun(winid: integer): boolean

---@param opts nil | tabman.OpenOpts
function M.open(opts)
  if not vim.api.nvim_buf_is_valid(bufferid) then
    bufferid = init_buffer()
  end

  if
    not vim.api.nvim_win_is_valid(winid)
    or not vim.tbl_contains(
      vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage()),
      winid
    )
  then
    winid = init_windows(bufferid)
  end
  if opts and opts.filter and type(opts.filter) == 'function' then
    tabman.filter = opts.filter
  else
    tabman.filter = nil
  end
  tabman.update_context()
end

return M
