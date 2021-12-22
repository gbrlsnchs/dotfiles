local features = require("features")
local util = require("lib.util")

if not features.tree_sitter.core:is_on() then
	return
end

util.packadd("nvim-treesitter")
local ts = require("nvim-treesitter.configs")

local settings = {
	highlight = { enable = true },
	indent = { enable = true },
	-- context_commentstring = {
	-- 	enable = true,
	-- },
}

if util.feature_is_on(features.tree_sitter.rainbow) then
	util.packadd("nvim-ts-rainbow")

	local palette = require("lib.colorscheme.palette")
	local rainbow = {
		palette.bright_red,
		palette.bright_green,
		palette.bright_blue,
		palette.bright_yellow,
		palette.bright_purple,
		palette.bright_cyan,
		palette.yellow,
	}

	local hex_rainbow = {}
	for _, color in ipairs(rainbow) do
		table.insert(hex_rainbow, tostring(color))
	end

	settings.rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
		colors = hex_rainbow,
	}
end

if util.feature_is_on(features.tree_sitter.auto_tagging) then
	util.packadd("nvim-ts-autotag")

	settings.autotag = {
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
	}
end

ts.setup(settings)

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
