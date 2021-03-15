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

	vim.api.nvim_exec([[
augroup treesitter
	autocmd!
	autocmd BufEnter * setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr() foldlevel=99
	autocmd BufEnter *.toml setfiletype toml
	autocmd TermOpen * TSBufDisable highlight
augroup END
	]], false)
end

M.run = ':TSUpdate'

return M
