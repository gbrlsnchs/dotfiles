local M = {}

function M.setup(_)
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
	vim.opt.cursorlineopt = "number"
	vim.opt.virtualedit = "block"
	vim.opt.list = true
	vim.opt.listchars = {
		tab = "›››",
		eol = "˜",
		trail = "×",
		nbsp = "‡",
		space = "·",
	}
	vim.opt.fillchars = {
		eob = "•",
	}
	vim.opt.signcolumn = "yes:1"
	vim.opt.colorcolumn = ""
	vim.opt.foldlevel = 10
	vim.opt.hidden = true
	vim.opt.updatetime = 200
	vim.opt.undofile = true
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.mouse = "a"
	vim.opt.splitright = true
	vim.opt.splitbelow = true

	vim.opt.termguicolors = true
	vim.opt.background = "light"
	vim.cmd("colorscheme me")

	vim.opt.completeopt = { "menu", "noinsert", "noselect" }
	vim.opt.pumheight = 10
end

return M
