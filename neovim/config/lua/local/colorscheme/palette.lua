local lush = require("lush")
local hsl = lush.hsl

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

	local normal_color = vim.env[normal_env_var]
	local bright_color = vim.env[light_env_var]

	palette[color_name] = hsl(normal_color)
	palette["bright_" .. color_name] = hsl(bright_color)
end

palette.bg = hsl(vim.env.background)
palette.fg = hsl(vim.env.foreground)

return palette
