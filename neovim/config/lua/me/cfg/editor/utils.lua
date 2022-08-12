local winpick = require("winpick")

local win = require("me.api.win")

local api = vim.api

local M = {}

function M.copy_buf_path()
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

function M.focus_win()
	win.focus(winpick.select({
		filter = function(winid, bufnr, default_filter)
			return default_filter(winid, bufnr, nil, true)
		end,
	}))
end

return M
