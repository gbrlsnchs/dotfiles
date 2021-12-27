local features = require("features")
local util = require("lib.util")

if not util.feature_is_on(features.indent_lines) then
	return
end

util.packadd("indent-blankline.nvim")

local indent_blankline = require("indent_blankline")

indent_blankline.setup({
	use_treesitter = true,
	show_trailing_blankline_indent = false,
	filetype_exclude = { "help", "lspinfo" },
	buftype_exclude = { "terminal" },
})
