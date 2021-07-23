return function()
	local compe = require("compe")

	compe.setup({
		source = {
			buffer = true,
			nvim_lsp = true,
			path = true,
			vsnip = true,
		},
	})

	local map_opts = {silent = true, expr = true}
	vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", map_opts)
	vim.api.nvim_set_keymap("i", "<CR>",      'compe#confirm("<CR>")', map_opts)
	vim.api.nvim_set_keymap("i", "<C-e>",     'compe#close("<C-e">)', map_opts)
	vim.api.nvim_set_keymap("i", "<C-e>",     'compe#scroll({ "delta": +4 })', map_opts)
	vim.api.nvim_set_keymap("i", "<C-e>",     'compe#scroll({ "delta": -4 })', map_opts)
end
