local M = {}

M.settings = {
	gopls = {
		experimentalWorkspaceModule = true,
		experimentalPostfixCompletions = true,
		codelenses = {
			generate = true,
			gc_details = true,
			test = true,
			tidy = true,
		},
	},
}

return M
