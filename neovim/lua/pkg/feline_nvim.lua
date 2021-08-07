return function()
	local colors = require("gruvbox.colors")
	local feline_defaults = require("feline.defaults")

	feline_defaults.colors = {
		bg = tostring(colors.dark0_soft),
		black = tostring(colors.dark0_hard),
		skyblue = tostring(colors.bright_blue),
		cyan = tostring(colors.faded_aqua),
		fg = tostring(colors.light2),
		green = tostring(colors.neutral_green),
		oceanblue = tostring(colors.faded_blue),
		magenta = tostring(colors.faded_purple),
		orange = tostring(colors.faded_orange),
		red = tostring(colors.bright_red),
		violet = tostring(colors.neutral_purple),
		white = tostring(colors.light2),
		yellow = tostring(colors.neutral_yellow),
	}

	require("feline").setup({
		preset = "noicon",
	})
end
