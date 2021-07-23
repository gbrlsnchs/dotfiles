return function()
	local ts = require("nvim-treesitter.configs")

	ts.setup({
		ensure_installed = "all",
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	})

	vim.opt.foldmethod = "expr"
	-- vim.opt.foldexpr = vim.fn["nvim_treesitter#foldexpr"]()
	vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
end
