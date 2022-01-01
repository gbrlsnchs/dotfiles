local buffers = require("lib.buffers")
local command = require("lib.command")

local cmd_group = "Buffers"

command.add("Buffers", "Search through buffers", buffers.find, {
	group = cmd_group,
	keymap = { keys = "<Leader>b?" },
})
