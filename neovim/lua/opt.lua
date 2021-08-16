vim.opt.termguicolors = true
vim.opt.compatible = false
vim.opt.showmode = false
vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.opt.pumheight = 10
vim.opt.title = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.shortmess = "aF"
vim.opt.diffopt = vim.opt.diffopt
	+ {
		"algorithm:patience",
		"indent-heuristic",
		"iwhiteall",
		"hiddenoff",
	}
vim.opt.backspace = "2"
vim.opt.virtualedit = "block"
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.listchars = {
	tab = "⇥ ",
	eol = "↴",
	trail = "␣",
	space = "·",
}
vim.opt.timeoutlen = 500
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.hidden = true
vim.opt.textwidth = 100
vim.opt.guicursor = ""
vim.opt.mouse = "a"
vim.opt.list = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "auto:9"
vim.opt.colorcolumn = "100"
vim.opt.foldlevel = 10

vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.g.mapleader = " "
vim.g.netrw_bufsettings = "noma nomod number relativenumber nobl nowrap ro"

vim.g.tex_flavor = "latex"

vim.api.nvim_exec(
	[[
augroup editor
	autocmd!
	autocmd BufReadPost * silent! lcd .
augroup END

augroup qf
	autocmd!
	autocmd FileType qf set nobuflisted
augroup END
]],
	false
)
