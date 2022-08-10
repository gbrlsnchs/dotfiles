local api = vim.api

local M = {}

--- Gets the window ID of the preview window.
--- @return number | nil: Window ID of the preview window.
function M.get_preview()
	local wins = api.nvim_list_wins()

	for _, win in ipairs(wins) do
		if api.nvim_win_get_option(win, "previewwindow") then
			return win
		end
	end

	return nil
end

--- Focuses a window of given ID.
--- @param win number: Window ID of windows to be focused.
--- @return boolean: Whether the window has been focused.
function M.focus(win)
	if not win then
		return false
	end

	api.nvim_set_current_win(win)
	return true
end

return M
