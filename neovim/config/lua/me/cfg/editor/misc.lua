local winpick = require("winpick")

local excmd = require("me.api.excmd")
local log = require("me.api.log")
local win = require("me.api.win")

local api = vim.api

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
			log.preview()
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

vim.keymap.set("t", "<S-Space>", "<Space>")
