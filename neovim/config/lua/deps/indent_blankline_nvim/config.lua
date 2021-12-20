return function()
	local indent_blankline = require("indent_blankline")

	indent_blankline.setup({
		use_treesitter = true,
		show_trailing_blankline_indent = false,
		filetype_exclude = { "bqfpreview", "help", "lspinfo", "packer", "startify" },
		buftype_exclude = { "terminal" },
	})
end
