local config = require("me.api.config")

if not config.get("editor", "preview") then
	return
end

local util = require("me.api.util")

local api = vim.api
local augroup = api.nvim_create_augroup("editor_preview", {})

util.packadd("float-preview.nvim")

api.nvim_create_autocmd("User", {
	pattern = "FloatPreviewWinOpen",
	callback = function()
		local preview_win = vim.g["float_preview#win"]
		local preview_buf = api.nvim_win_get_buf(preview_win)

		api.nvim_win_set_option(preview_win, "list", false)
		api.nvim_win_set_option(preview_win, "number", false)
		api.nvim_win_set_option(preview_win, "cursorline", false)
		api.nvim_buf_set_option(preview_buf, "filetype", "markdown")
	end,
	group = augroup,
})

vim.g["float_preview#docked"] = false
vim.g["float_preview#max_width"] = 100

vim.keymap.set("i", "<C-d>", function()
	local float_win = vim.g["float_preview#win"]
	if float_win == 0 then
		return "<C-d>"
	end

	local scroll = vim.opt.scroll:get()
	local cursor = api.nvim_win_get_cursor(float_win)
	local float_buf = api.nvim_win_get_buf(float_win)
	local remaining = api.nvim_buf_line_count(float_buf) - cursor[1]
	cursor[1] = cursor[1] + math.min(scroll, remaining)

	api.nvim_win_set_cursor(float_win, cursor)
end, { expr = true })

vim.keymap.set("i", "<C-u>", function()
	local float_win = vim.g["float_preview#win"]
	if float_win == 0 then
		return "<C-u>"
	end

	local scroll = vim.opt.scroll:get()
	local cursor = api.nvim_win_get_cursor(float_win)
	local remaining = cursor[1] - 1
	cursor[1] = cursor[1] - math.min(scroll, remaining)

	api.nvim_win_set_cursor(float_win, cursor)
end, { expr = true })
