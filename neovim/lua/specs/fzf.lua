local M = {'junegunn/fzf.vim'}

M.cond = function()
	return vim.fn.executable('fzf') == 1
end

M.setup = function()
	vim.g.fzf_layout = {
		window = {
			width = 0.8,
			height = 0.5,
			highlight = 'Comment',
		},
	}
end

M.requires = {require('specs.lspfuzzy')}

return M
