vim.opt.termguicolors = true

-- Statusline and Tabline
vim.opt.laststatus = 2
vim.opt.showtabline = 2

-- Completion menu.
vim.opt.pumheight = 10

-- Search.
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

--
vim.opt.shortmess = "aF"

-- Diff.
vim.opt.diffopt = vim.opt.diffopt
	+ {
		"algorithm:patience",
		"indent-heuristic",
		"iwhiteall",
		"hiddenoff",
	}

-- Typeset.
vim.opt.expandtab = false
vim.opt.backspace = "2"
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 100

-- Editor.
vim.opt.title = true
vim.opt.guicursor = ""
vim.opt.cursorline = true
vim.opt.virtualedit = "block"
vim.opt.list = false
vim.opt.listchars = {
	tab = "⇥ ",
	eol = "↴",
	trail = "␣",
	space = "·",
}
vim.opt.fillchars = {
	vert = " ",
	eob = "•",
}
vim.opt.signcolumn = "auto:9"
vim.opt.colorcolumn = "100"
vim.opt.foldlevel = 10
vim.opt.hidden = true
vim.opt.updatetime = 1000
vim.opt.undofile = true

-- Windows.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Navigation.
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true

-- Internals.
vim.opt.timeoutlen = 500

-- Grep.
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.g.mapleader = " "

-- Netrw.
vim.g.netrw_bufsettings = "noma nomod number relativenumber nobl nowrap ro"
vim.g.netrw_browsex_viewer = "xdg-open"

-- Patches.
vim.g.tex_flavor = "latex"

vim.cmd([[
" Open buffers using relative paths.
augroup editor
	autocmd!
	autocmd BufReadPost * silent! lcd .
augroup END

" Self-explanatory!
augroup highlight_yank
	autocmd!
	autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END
]])

-- TODO: Set up env variables in order to use neovim-remote with Git.
