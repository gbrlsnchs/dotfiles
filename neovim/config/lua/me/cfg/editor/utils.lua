local winpick = require("winpick")

local win = require("me.api.win")

local api = vim.api

local function buf_rel_name(name)
	return vim.fn.fnamemodify(name, ":~:.")
end

local M = {}

function M.copy_buf_path()
	local selected_win = winpick.select()
	if not selected_win then
		return
	end

	local bufnr = api.nvim_win_get_buf(selected_win)
	local buf_name = api.nvim_buf_get_name(bufnr)

	if not buf_name then
		return
	end

	vim.fn.setreg("+", buf_rel_name(buf_name))
end

function M.focus_win()
	win.focus(winpick.select({
		buf_excludes = false,
		win_excludes = false,
	}))
end

return M
