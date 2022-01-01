local fuzzy = require("lib.fuzzy")
local terminal = require("lib.terminal")
local enums = require("lib.enums")
local command = require("lib.command")
local command_util = require("lib.command.util")

command.add("TermOpen", "Open terminal instance", command_util.bind_fargs(terminal.open), {
	nargs = "?",
	complete = enums.list_orientations,
	actions = {
		[fuzzy.action_types.C_X] = {
			arg = enums.orientations.horizontal,
			keymap = {
				keys = "<Leader>ts",
			},
		},
		[fuzzy.action_types.C_V] = {
			arg = enums.orientations.vertical,
			keymap = {
				keys = "<Leader>tv",
			},
		},
		[fuzzy.action_types.C_T] = {
			arg = enums.orientations.tabnew,
			keymap = {
				keys = "<Leader>tt",
			},
		},
	},
	keymap = { keys = "<Leader>to" },
})
