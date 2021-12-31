local files = require("lib.files")
local command = require("lib.command")
local command_util = require("lib.command.util")

local wrap_cmd_opts = command_util.create_opts_factory({ group = "Files" })

vim.cmd([[
augroup files
	autocmd!
	autocmd VimEnter * lua require("lib.files").init_session()
	autocmd BufWinEnter ?* lua require("lib.files").increment_view_count()
	autocmd BufDelete ?* lua require("lib.files").check_view_entry()
augroup END
]])

command.add(
	"Find a file or directory",
	wrap_cmd_opts({
		name = "FindFile",
		nargs = "?",
		complete = "dir",
		exec = 'lua require("lib.files").find(<f-args>)',
		mappings = { bind = "<Leader>ff" },
	})
)

command.add(
	"Find a dirty file",
	wrap_cmd_opts({
		name = "FindDirtyFile",
		nargs = "?",
		complete = "dir",
		exec = 'lua require("lib.files").find_dirty(<f-args>)',
		mappings = { bind = "<Leader>fd" },
	})
)

command.add(
	"Find recent files",
	wrap_cmd_opts({
		name = "FindOldfiles",
		exec = 'lua require("lib.files").find_oldfiles()',
		mappings = { bind = "<Leader>fo" },
	})
)
