local files = require("lib.files")
local command = require("lib.command")
local command_util = require("lib.command.util")

vim.cmd([[
augroup files
	autocmd!
	autocmd VimEnter * lua require("lib.files").init_session()
	autocmd BufWinEnter ?* lua require("lib.files").increment_view_count()
	autocmd WinEnter * if &g:relativenumber | setlocal relativenumber | endif
	autocmd WinLeave * setlocal norelativenumber
	autocmd BufDelete ?* lua require("lib.files").check_view_entry()
augroup END
]])

local cmd_group = "Files"

command.add("FindFile", "Find a file or directory", command_util.bind_fargs(files.find), {
	group = cmd_group,
	nargs = "?",
	complete = "dir",
	keymap = { keys = "<Leader>ff" },
})

command.add("FindDirtyFile", "Find a dirty file", command_util.bind_fargs(files.find_dirty), {
	group = cmd_group,
	nargs = "?",
	complete = "dir",
	keymap = { keys = "<Leader>fd" },
})

command.add("FindOldfiles", "Find recent files", files.find_oldfiles, {
	group = cmd_group,
	keymap = { keys = "<Leader>fo" },
})
