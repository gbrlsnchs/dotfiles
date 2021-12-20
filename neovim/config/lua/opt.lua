vim.opt.termguicolors = true

-- Statusline and Tabline

-- Completion menu.

-- Search.

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

-- Editor.

-- Windows.

-- Navigation.

-- Internals.
vim.opt.timeoutlen = 500

-- Grep.
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Netrw.
vim.g.netrw_bufsettings = "noma nomod number relativenumber nobl nowrap ro"
vim.g.netrw_browsex_viewer = "xdg-open"

-- Patches.


-- TODO: Set up env variables in order to use neovim-remote with Git.
