local M = {}

local focused_win_var = "lib_focused_win"

function M.get_focused_win()
	return vim.g[focused_win_var]
end

function M.set_focused_win()
	vim.g[focused_win_var] = vim.api.nvim_get_current_win()
end

return M
