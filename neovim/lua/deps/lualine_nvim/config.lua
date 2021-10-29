return function()
	local function get_diff_source()
		local gitsigns = vim.b.gitsigns_status_dict
		if gitsigns then
			return {
				added = gitsigns.added,
				modified = gitsigns.changed,
				removed = gitsigns.removed,
			}
		end
	end

	local function get_filename()
		return vim.b.term_name or vim.b.term_title or vim.fn.expand("%~"):gsub("/", " ᐳ ")
	end

	local function get_lsp_clients()
		local clients = vim.lsp.buf_get_clients()
		local client_names = {}
		for _, client in pairs(clients) do
			table.insert(client_names, client.name)
		end
		if #client_names == 0 then
			return "LSP off"
		end

		table.sort(client_names, function(a, b)
			return a < b
		end)

		return ("LSP on (%s)"):format(table.concat(client_names, ", "))
	end

	local function get_gps_location()
		local gps = require("nvim-gps")

		if not gps.is_available() then
			return ""
		end

		return gps.get_location()
	end

	local lualine = require("lualine")

	lualine.setup({
		options = {
			theme = "gruvbox",
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "/" },
			icons_enabled = false,
			disabled_filetypes = {},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {
				"b:gitsigns_head",
			},
			lualine_c = {
				{ "diff", source = get_diff_source },
				{
					"diagnostics",
					sources = { "nvim_lsp" },
				},
				"%=",
				get_gps_location,
			},
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
				get_lsp_clients,
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { get_filename },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {
			lualine_a = { get_filename },
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = { "lsp_progress" },
			lualine_z = { "tabs" },
		},
		extensions = {},
	})
end
