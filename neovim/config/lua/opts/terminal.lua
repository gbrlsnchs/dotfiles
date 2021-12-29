local command = require("lib.command")
local fuzzy = require("lib.fuzzy")
local enums = require("lib.enums")

command.add("Open terminal instance", {
	name = "TermOpen",
	nargs = "?",
	complete = 'customlist,v:lua.require("lib.enums").list_orientations',
	exec = 'lua require("lib.terminal").open(<f-args>)',
	actions = {
		[fuzzy.action_types.C_X] = {
			arg = enums.orientations.horizontal,
			mappings = {
				bind = "<Leader>ts",
			},
		},
		[fuzzy.action_types.C_V] = {
			arg = enums.orientations.vertical,
			mappings = {
				bind = "<Leader>tv",
			},
		},
		[fuzzy.action_types.C_T] = {
			arg = enums.orientations.tabnew,
			mappings = {
				bind = "<Leader>tt",
			},
		},
	},
	mappings = { bind = "<Leader>to" },
})
