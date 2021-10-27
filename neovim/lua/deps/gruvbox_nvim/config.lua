return function()
	vim.opt.background = vim.env.NVIM_BACKGROUND_MODE or "light"
	vim.cmd("colorscheme gruvbox")
end
