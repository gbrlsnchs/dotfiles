local M = {'hrsh7th/nvim-compe'}

M.requires = {
	{'hrsh7th/vim-vsnip'},
}

M.setup = function()
	vim.o.completeopt = table.concat({'menu', 'menuone', 'noselect'}, ',')

	local map_opts = {silent = true, expr = true}
	local set_keymap = vim.api.nvim_set_keymap

	set_keymap('i', '<C-Space>', 'compe#complete()', map_opts)
	set_keymap('i', '<CR>',      'compe#confirm("<CR>")', map_opts)
	set_keymap('i', '<C-e>',     'compe#close("<C-e">)', map_opts)
	set_keymap('i', '<C-e>',     'compe#scroll({ "delta": +4 })', map_opts)
	set_keymap('i', '<C-e>',     'compe#scroll({ "delta": -4 })', map_opts)
end

M.config = function()
	require('compe').setup({
		source = {
			nvim_lsp = require('utils.lsp').is_enabled(),
		},
	})
end

return M
