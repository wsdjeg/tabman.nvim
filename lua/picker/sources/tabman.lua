local M = {}

local previewer = require("picker.previewer.buffer")

local get_icon

function M.set()
	local ok, devicon = pcall(require, "nvim-web-devicons")
	if ok then
		get_icon = devicon.get_icon
	end
end

function M.get()
	local windows = vim.tbl_filter(function(win)
		return #vim.api.nvim_win_get_config(win).relative == 0
	end, vim.api.nvim_list_wins())

	return vim.tbl_map(function(win)
		local t = vim.api.nvim_win_get_buf(win)
		if get_icon then
			local bufname = vim.api.nvim_buf_get_name(t)
			local base_name = vim.fn.fnamemodify(bufname, ":t")
			local icon, hl = get_icon(base_name)
			local str = vim.fn.fnamemodify(bufname, ":.")
			return {
				str = (icon or "󰈔") .. " " .. str,
				win = win,
				highlight = {
					{ 0, 2, hl },
					{ 3, #str - #base_name + 4, "Comment" },
				},
			}
		else
			return {
				win = win,
				str = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(t), ":."),
			}
		end
	end, windows)
end

function M.default_action(s)
	vim.api.nvim_set_current_win(s.win)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	local line = vim.api.nvim_win_get_cursor(item.win)[1]
	previewer.buflines = vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(item.win), 0, -1, false)
	previewer.filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(item.win) })
	previewer.preview(line, win, buf, true)
end

return M
