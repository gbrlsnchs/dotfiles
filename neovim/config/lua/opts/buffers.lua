local buffers = require("lib.buffers")
local command = require("lib.command")
local command_util = require("lib.command.util")

local wrap_cmd_opts = command_util.create_opts_factory({ group = "Buffers" })

command.add(
	"Search through buffers",
	wrap_cmd_opts({
		name = "Buffers",
		exec = 'lua require("lib.buffers").find()',
		mappings = { bind = "<Leader>b?" },
	})
)
