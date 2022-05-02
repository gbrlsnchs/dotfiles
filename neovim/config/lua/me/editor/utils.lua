local winpick = require("winpick")

local api = vim.api

local function buf_rel_name(name)
	return vim.fn.fnamemodify(name, ":~:.")
end

local M = {}

function M.copy_buf_path()
	local win = winpick.select()
	if not win then
		return
	end

	local bufnr = api.nvim_win_get_buf(win)
	local buf_name = api.nvim_buf_get_name(bufnr)

	if not buf_name then
		return
	end

	vim.fn.setreg("+", buf_rel_name(buf_name))
end

function M.focus_win()
	winpick.focus({
		buf_excludes = false,
		win_excludes = false,
	})
end

return M
