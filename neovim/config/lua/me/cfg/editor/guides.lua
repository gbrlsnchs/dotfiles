local config = require("me.api.config")

if not config.get("editor", "indent_guides") then
	return
end

local util = require("me.api.util")

util.packadd("indent-blankline.nvim")

local indent_blankline = require("indent_blankline")

indent_blankline.setup({
	use_treesitter = config.get("editor", "treesitter", "enabled"),
	show_trailing_blankline_indent = false,
	filetype_exclude = { "help", "lspinfo" },
	buftype_exclude = { "nofile", "terminal" },
})
