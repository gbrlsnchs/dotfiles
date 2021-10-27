local api = vim.api

local floats = {}

local M = {}

function M.show_visual_cues(wins)
	-- Reset view.
	M.hide_visual_cues()

	local result = {}
	for idx, win in ipairs(wins) do
		local ascii_code = idx + 64 -- A, B, C, ...
		local bufnr = api.nvim_create_buf(false, true)

		api.nvim_buf_set_lines(bufnr, 0, -1, false, {
			"         ",
			("    %s    "):format(vim.fn.nr2char(ascii_code)),
			"         ",
		})

		local width = 9
		local height = 3
		local float_winid = api.nvim_open_win(bufnr, false, {
			relative = "win",
			win = win,
			width = width,
			height = height,
			col = math.floor(api.nvim_win_get_width(win) / 2 - width / 2),
			row = math.floor(api.nvim_win_get_height(win) / 2 - height / 2),
			style = "minimal",
			border = "single",
		})

		table.insert(floats, float_winid)
		result[ascii_code] = win
	end

	vim.cmd("redraw")
	return result
end

function M.hide_visual_cues()
	for _, winid in pairs(floats) do
		pcall(api.nvim_win_close, winid, true)
	end
	floats = {}
end

return M
