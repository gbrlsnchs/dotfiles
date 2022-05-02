local api = vim.api

local focused_win

local M = {}

--- Gets the window ID of the preview window.
--- @return number: Window ID of the preview window.
function M.get_preview()
	local wins = api.nvim_list_wins()

	for _, win in ipairs(wins) do
		if api.nvim_win_get_option(win, "previewwindow") then
			return win
		end
	end

	return nil
end

--- Gets currently focused window.
--- @return number: Window ID of currently focused window.
function M.get_focused()
	return focused_win
end

--- Sets focused window as the current one.
function M.set_focused()
	focused_win = api.nvim_get_current_win()
end

return M
