local grep = require("lib.grep")
local command = require("lib.command")
local command_util = require("lib.command.util")

vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

local wrap_cmd_opts = command_util.create_opts_factory({ group = "Grep" })

command.add(
	"Search",
	wrap_cmd_opts({
		name = "Grep",
		nargs = "*",
		exec = 'lua require("lib.grep").search(<f-args>)',
		mappings = { bind = "<Leader>gg" },
	})
)

command.add(
	"Search with Git",
	wrap_cmd_opts({
		name = "GitGrep",
		nargs = "*",
		exec = 'lua require("lib.grep").git_search(<f-args>)',
		mappings = { bind = "<Leader>gG" },
	})
)
