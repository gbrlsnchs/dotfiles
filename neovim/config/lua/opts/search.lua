local grep = require("lib.grep")
local command = require("lib.command")
local command_util = require("lib.command.util")

vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

local cmd_group = "Grep"

command.add("Grep", "Search", command_util.bind_fargs(grep.search), {
	group = cmd_group,
	nargs = "*",
	keymap = { keys = "<Leader>gg" },
})

command.add("GrepCd", "Search in buffer's current directory", command_util.bind_fargs(grep.search_in_dir), {
	group = cmd_group,
	nargs = "*",
	keymap = { keys = "<Leader>gd" },
})

command.add("GitGrep", "Search with Git", command_util.bind_fargs(grep.git_search), {
	group = cmd_group,
	nargs = "*",
	keymap = { keys = "<Leader>gG" },
})
