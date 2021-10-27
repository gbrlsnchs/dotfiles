return function()
	local ts = require("nvim-treesitter.configs")

	local colors = require("gruvbox.colors")
	local ts_rainbow_colors = {
		colors.neutral_red, -- red
		colors.neutral_orange, -- orange
		colors.neutral_yellow, -- yellow
		colors.neutral_green, -- green
		colors.neutral_blue, -- blue
		colors.neutral_aqua, -- indigo (cyan actually)
		colors.neutral_purple, -- violet (magenta actually)
	}

	local hex_colors = {}
	for _, color in ipairs(hex_colors) do
		table.insert(hex_colors, tostring(color))
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
			colors = ts_rainbow_colors.normal,
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
	-- vim.opt.foldexpr = vim.fn["nvim_treesitter#foldexpr"]()
	vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
end
