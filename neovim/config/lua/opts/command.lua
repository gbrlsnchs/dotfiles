local command = require("lib.command")

command.add("CommandPalette", "Show command palette", command.open_palette, {
	keymap = { keys = "<Leader><Tab>" },
})
