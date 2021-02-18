local M = {'nvim-treesitter/nvim-treesitter'}

M.config = function()
	require('nvim-treesitter.configs').setup({
		ensure_installed = 'all',
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	})

	vim.wo.foldmethod = 'expr'
	vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
end

M.run = ':TSUpdate'

return M
