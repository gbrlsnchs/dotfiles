-- {{notice}}

local lush = require("lush")
local hsl = lush.hsl

local colors = {
	background = "#{{background}}",
	foreground = "#{{foreground}}",
	color0 = "#{{color0}}",
	color1 = "#{{color1}}",
	color2 = "#{{color2}}",
	color3 = "#{{color3}}",
	color4 = "#{{color4}}",
	color5 = "#{{color5}}",
	color6 = "#{{color6}}",
	color7 = "#{{color7}}",
	color8 = "#{{color8}}",
	color9 = "#{{color9}}",
	color10 = "#{{color10}}",
	color11 = "#{{color11}}",
	color12 = "#{{color12}}",
	color13 = "#{{color13}}",
	color14 = "#{{color14}}",
	color15 = "#{{color15}}",
}

local color_names = {
	"black",
	"red",
	"green",
	"yellow",
	"blue",
	"purple",
	"cyan",
	"gray",
}

local palette = {}
for i, color_name in ipairs(color_names) do
	local normal_variant_idx = i - 1
	local light_variant_idx = normal_variant_idx + 8

	local normal_env_var = ("color%d"):format(normal_variant_idx)
	local light_env_var = ("color%d"):format(light_variant_idx)

	local normal_color = colors[normal_env_var]
	local bright_color = colors[light_env_var]

	palette[color_name] = hsl(normal_color)
	palette["bright_" .. color_name] = hsl(bright_color)
end

palette.bg = hsl(colors.background)
palette.fg = hsl(colors.foreground)

return palette
