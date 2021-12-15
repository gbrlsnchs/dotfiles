return function()
	local ts = require("nvim-treesitter.configs")

	local palette = require("local.colorscheme.palette")
	local rainbow = {
		palette.bright_red,
		palette.bright_green,
		palette.bright_blue,
		palette.bright_yellow,
		palette.bright_purple,
		palette.bright_cyan,
		palette.bright_gray,
	}

	local hex_rainbow = {}
	for _, color in ipairs(rainbow) do
		table.insert(hex_rainbow, tostring(color))
	end

	ts.setup({
		ensure_installed = "all",
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		context_commentstring = {
			enable = true,
		},
		rainbow = {
			enable = true,
			extended_mode = true,
			max_file_lines = nil,
			colors = hex_rainbow,
		},
		autotag = {
			enable = true,
			filetypes = {
				"html",
				"javascript",
				"javascriptreact",
				"typescriptreact",
				"svelte",
				"vue",
				"xml",
			},
		},
	})

	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = vim.fn["nvim_treesitter#foldexpr"]()
end
