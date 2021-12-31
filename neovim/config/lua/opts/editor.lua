vim.opt.expandtab = false
vim.opt.backspace = "2"
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 100
vim.opt.title = true
vim.opt.guicursor = ""
vim.opt.cursorline = true
vim.opt.virtualedit = "block"
vim.opt.list = true
vim.opt.listchars = {
	tab = "⇥ ",
	eol = "↴",
	trail = "␣",
	space = "•",
}
vim.opt.fillchars = {
	vert = " ",
	eob = "▸",
}
vim.opt.signcolumn = "auto:9"
vim.opt.colorcolumn = ""
vim.opt.foldlevel = 10
vim.opt.hidden = true
vim.opt.updatetime = 1000
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.cmd([[
" Open buffers using relative paths.
augroup editor
	autocmd!
	autocmd BufReadPost * silent! lcd .
	autocmd TextYankPost * silent! lua vim.highlight.on_yank()
	autocmd TermOpen * startinsert
augroup END
]])
