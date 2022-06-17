local log = require("me.api.log")
local win = require("me.api.win")

local api = vim.api

local M = {}

function M.preview()
	-- HACK: This forces the preview to open when current window doesn't have a file name.
	local tmp = vim.fn.tempname()
	vim.cmd("pedit " .. tmp)

	local preview_win = win.get_preview()
	local logs_buffer = log.get_buffer()

	api.nvim_win_set_buf(preview_win, logs_buffer)
	api.nvim_win_set_option(preview_win, "number", false)
	api.nvim_win_set_option(preview_win, "relativenumber", false)
	api.nvim_win_set_option(preview_win, "list", false)
	api.nvim_win_call(preview_win, function()
		vim.cmd("wincmd J | normal G")
	end)

	vim.cmd("bdelete " .. tmp)

	log.reset_unread()
end

return M
