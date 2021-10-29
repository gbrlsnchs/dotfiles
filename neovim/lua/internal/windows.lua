local util = require("internal.windows.util")

local api = vim.api

local M = {}

function M.pick_window()
	local wins = api.nvim_tabpage_list_wins(0)

	if #wins == 1 then
		return wins[1]
	end

	wins = vim.tbl_filter(function(winid)
		local bufnr = api.nvim_win_get_buf(winid)
		return vim.fn.buflisted(bufnr) == 1
	end, wins)

	if #wins == 1 then
		return wins[1]
	end

	local mapped_wins = util.show_visual_cues(wins)
	local winid

	print("Pick a window: ")
	while not winid do
		local ok, choice = pcall(vim.fn.getchar)
		if not ok or tonumber(choice) == 27 then -- if Ctrl-C or Esc
			util.hide_visual_cues()
			vim.cmd("mode")
			return false
		end
		choice = vim.fn.nr2char(choice):upper()
		local ascii_code = vim.fn.char2nr(choice)
		winid = mapped_wins[ascii_code]
	end

	util.hide_visual_cues()
	api.nvim_set_current_win(winid)

	return true
end

return M
