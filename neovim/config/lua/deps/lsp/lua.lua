local nvim_data = vim.fn.stdpath("data")

return {
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			workspace = {
				library = {
					[vim.env.VIMRUNTIME] = true,
					[nvim_data .. "/pack/*/start/*"] = true,
					[nvim_data .. "/pack/*/opt/*"] = true,
					[nvim_data .. "/rocks/*"] = true,
				},
				maxPreload = 2000,
				preloadFileSize = 50000,
			},
			diagnostics = {
				globals = { "vim" },
			},
			telemetry = { enable = false },
		},
	},
}
