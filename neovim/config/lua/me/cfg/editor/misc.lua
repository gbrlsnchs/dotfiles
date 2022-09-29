local winpick = require("winpick")

local excmd = require("me.api.excmd")
local log = require("me.api.log")
local win = require("me.api.win")

local api = vim.api

local function preview_logs()
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

local function copy_buf_path()
	local winid, bufnr = winpick.select({
		format_label = winpick.defaults.format_label,
		filter = function(winid, bufnr, default_filter)
			if api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
				return false
			end

			return default_filter(winid, bufnr)
		end,
	})

	if not winid then
		return
	end

	local name = api.nvim_buf_get_name(bufnr)
	if name then
		vim.fn.setreg("+", vim.fn.fnamemodify(name, ":~:."))
	end
end

local function focus_win()
	win.focus(winpick.select({
		filter = function(winid, bufnr, default_filter)
			return default_filter(winid, bufnr, nil, true)
		end,
	}))
end

excmd.register("Utils", {
	Logs = {
		desc = "Show Neovim logs in preview window",
		callback = function()
			preview_logs()
		end,
	},
	CopyBufPath = {
		desc = "Copy buffer path of selected buffer",
		callback = function()
			copy_buf_path()
		end,
		opts = {
			keymap = { keys = "<Leader>uc" },
		},
	},
	FocusWin = {
		desc = "Focus selected window",
		callback = function()
			focus_win()
		end,
		opts = {
			keymap = { keys = "<Leader>uf" },
		},
	},
})
