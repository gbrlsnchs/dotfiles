vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }
vim.opt.pumheight = 10

local augroup_id = vim.api.nvim_create_augroup("completion", {})

vim.api.nvim_create_autocmd("User", {
	pattern = "FloatPreviewWinOpen",
	callback = function()
		local preview_win = vim.g["float_preview#win"]

		vim.api.nvim_win_set_option(preview_win, "list", false)
	end,
	group = augroup_id,
})
