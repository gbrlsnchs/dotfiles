local M = {'iamcco/markdown-preview.nvim'}

M.run = 'cd app && yarn install'

M.cmd = 'MarkdownPreview'

M.ft = {'markdown', 'plantuml'}

M.config = function()
	vim.cmd([[
function! g:Open_browser(url)
	silent exec 'silent !chromium --new-window ' . a:url
endfunction
	]])

	vim.g.mkdp_filetypes = {'markdown', 'plantuml'}
	vim.g.mkdp_browserfunc = 'g:Open_browser'
end

M.cond = function()
	return vim.fn.executable('yarn') == 1
end

return M
