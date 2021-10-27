return function()
	local lualine = require("lualine")

	lualine.setup({
		options = {
			theme = "gruvbox",
			section_separators = {},
			component_separators = { "/", "/" },
			icons_enabled = false,
			disabled_filetypes = {},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = { "filename" },
			lualine_x = {
				{
					"diagnostics",
					sources = { "nvim_lsp" },
				},
				"encoding",
				"fileformat",
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {
			lualine_z = { "lsp_progress" },
		},
		extensions = {},
	})
end
