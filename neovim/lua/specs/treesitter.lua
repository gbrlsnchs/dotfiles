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

	vim.cmd('augroup treesitter')
	vim.cmd('autocmd!')
	vim.cmd('autocmd BufEnter * setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr() foldlevel=99')
	vim.cmd('autocmd TermOpen * TSBufDisable highlight')
	vim.cmd('augroup END')
end

M.run = ':TSUpdate'

return M
