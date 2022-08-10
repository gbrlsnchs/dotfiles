local winpick = require("winpick")

local win = require("me.api.win")

local api = vim.api

local M = {}

function M.copy_buf_path()
	local winid, bufnr = winpick.select({
		format_label = winpick.defaults.format_label,
		filter = function(winid, bufnr)
			if api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
				return false
			end

			return winpick.defaults.filter(winid, bufnr)
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
		filter = M.pick_filter,
	}))
end

function M.pick_filter(winid, _)
	local win_var_denylist = {
		"treesitter_context",
		"treesitter_context_line_number",
	}

	for _, var in ipairs(win_var_denylist) do
		if pcall(api.nvim_win_get_var, winid, var) then
			return false
		end
	end

	return true
end

return M
