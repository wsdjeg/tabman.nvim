local M = {}

local bufferid = -1
local winid = -1

---@return integer
local function init_buffer()
	local buf = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
	vim.api.nvim_set_option_value("list", false, { buf = buf })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
	vim.api.nvim_set_option_value("warp", false, { buf = buf })
	vim.api.nvim_set_option_value("cursorline", false, { buf = buf })
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
	vim.api.nvim_set_option_value("spell", false, { buf = buf })

	return buf
end

---@return integer
local function init_windows(buf)
	local win = vim.api.nvim_open_win(buf, true, {
		split = "left",
		width = 30,
	})

	vim.api.nvim_set_option_value("number", false, { win = win })
	vim.api.nvim_set_option_value("relativenumber", false, { win = win })
	vim.api.nvim_set_option_value("winfixwidth", true, { win = win })

	return win
end

function M.open()
	if not vim.api.nvim_buf_is_valid(bufferid) then
		bufferid = init_buffer()
	end

	if
		not vim.api.nvim_win_is_valid(winid)
		or not vim.tbl_contains(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage()), winid)
	then
        winid = init_windows(bufferid)
	end
end

return M
