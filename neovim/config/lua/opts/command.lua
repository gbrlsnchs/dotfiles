local command = require("lib.command")

command.add("Show command palette", {
	name = "CommandPalette",
	exec = 'lua require("lib.command").open_palette()',
	mappings = { bind = "<Leader><Tab>" },
})
