local winpick = require("winpick")

local excmd = require("me.api.excmd")
local util = require("me.api.util")
local palette = require("me.editor.palette")
local files = require("me.editor.files")
local grep = require("me.editor.grep")
local terminal = require("me.editor.terminal")
local buffers = require("me.editor.buffers")
local utils = require("me.editor.utils")
local logs = require("me.editor.logs")

local api = vim.api

--- Sets up EX commands for the command palette.
local function setup_palette()
	excmd.register("Commands", {
		CommandPalette = {
			desc = "Open command palette",
			callback = function()
				palette.open()
			end,
			opts = {
				keymap = { keys = "<Leader><Tab>" },
			},
		},
	})

end

--- Sets up EX commands for file operations.
local function setup_files()
	excmd.register("Files", {
		FindFiles = {
			desc = "Find files in the project",
			callback = util.with_fargs(function(base_dir)
				files.find(base_dir)
			end),
			opts = {
				nargs = "?",
				complete = "dir",
				keymap = { keys = "<Leader>ff" },
				actions = {
					["ctrl-s"] = {
						desc = "in current file directory",
						arg = function(bufnr)
							return util.get_buf_base_dir(bufnr, "./")
						end,
						keymap = { keys = "<Leader>fF" },
					},
				},
			},
		},
		FindChangedFiles = {
			desc = "Find changed files, modified or new",
			callback = util.with_fargs(function(base_dir)
				files.find_changed(base_dir)
			end),
			opts = {
				nargs = "?",
				complete = "dir",
				keymap = { keys = "<Leader>fd" },
				actions = {
					["ctrl-s"] = {
						desc = "in current file directory",
						arg = function(bufnr)
							return util.get_buf_base_dir(bufnr, ".")
						end,
						keymap = { keys = "<Leader>fD" },
					},
				},
			},
		},
	})
end

--- Sets up EX commands for grep operations.
local function setup_grep()
	excmd.register("Grep", {
		Grep = {
			desc = "Search text in files",
			callback = util.with_fargs(function(query)
				grep.search(query)
			end),
			opts = {
				nargs = "*",
				keymap = { keys = "<Leader>gf" },
			},
		},
		GrepCd = {
			desc = "Search text in files from current directory",
			callback = util.with_fargs(function(query)
				grep.search(query, { global = false })
			end),
			opts = {
				nargs = "*",
				keymap = { keys = "<Leader>gF" },
			},
		},
		GitGrep = {
			desc = "Search text in files using Git",
			callback = util.with_fargs(function(query)
				grep.git_search(query)
			end),
			opts = {
				nargs = "*",
				keymap = { keys = "<Leader>gg" },
			},
		},
		GitGrepCd = {
			desc = "Search text in files for current directory using Git",
			callback = util.with_fargs(function(query)
				grep.git_search(query, { global = false })
			end),
			opts = {
				nargs = "*",
				keymap = { keys = "<Leader>gG" },
			},
		}
	})
end

--- Sets up terminal commands.
local function setup_terminal()
	excmd.register("Terminal", {
		TermOpen = {
			desc = "Opens a new terminal instance",
			callback = util.with_fargs(function(orientation)
				terminal.open(orientation)
			end),
			opts = {
				nargs = "?",
				complete = function()
					return { "horizontal", "vertical", "tab" }
				end,
				keymap = { keys = "<Leader>to" },
				actions = {
					["ctrl-x"] = {
						arg = "horizontal",
						keymap = { keys = "<Leader>ts" },
					},
					["ctrl-v"] = {
						arg = "vertical",
						keymap = { keys = "<Leader>tv" },
					},
					["ctrl-t"] = {
						arg = "tab",
						keymap = { keys = "<Leader>tt" },
					},
				},
			},
		},
	})
end

--- Sets up buffer commands.
local function setup_buffers()
	excmd.register("Buffers", {
		Buffers = {
			desc = "Search through open buffers",
			callback = function()
				buffers.find()
			end,
			opts = {
				keymap = { keys = "<Leader>b?" },
			},
		},
	})
end

--- Sets up log commands.
local function setup_logs()
	excmd.register("Logs", {
		Logs = {
			desc = "Show Neovim logs in preview window",
			callback = function()
				logs.preview()
			end,
		},
	})
end

--- Sets up utilitaries.
local function setup_utils()
	excmd.register("Utils", {
		CopyBufPath = {
			desc = "Copy buffer path of selected buffer",
			callback = function()
				utils.copy_buf_path()
			end,
			opts = {
				keymap = { keys = "<Leader>uc" },
			},
		},
		FocusWin = {
			desc = "Focus selected window",
			callback = function()
				utils.focus_win()
			end,
			opts = {
				keymap = { keys = "<Leader>uf" },
			},
		},
	})
end

--- Sets up automatic commands.
local function setup_autocmds()
	local group = api.nvim_create_augroup("editor", {})
	api.nvim_create_autocmd("BufReadPost", {
		group = group,
		pattern = "*",
		command = "silent! lcd .",
	})
	api.nvim_create_autocmd("TextYankPost", {
		group = group,
		pattern = "*",
		callback = function()
			vim.highlight.on_yank()
		end,
	})
	api.nvim_create_autocmd("TermOpen", {
		group = group,
		pattern = "*",
		command = "startinsert",
	})

	api.nvim_create_autocmd("User", {
		pattern = "FloatPreviewWinOpen",
		callback = function()
			local preview_win = vim.g["float_preview#win"]

			api.nvim_win_set_option(preview_win, "list", false)
			api.nvim_win_set_option(preview_win, "number", false)
			api.nvim_win_set_option(preview_win, "relativenumber", false)
			api.nvim_win_set_option(preview_win, "cursorline", false)
		end,
		group = group,
	})
end

local M = {}

--- Sets up core editor functions.
function M.setup(opts)
	opts = util.tbl_merge(opts, {
		cfilter = true,
	})

	-- Disable Netrw so Dirvish can take over.
	vim.g.loaded_netrwPlugin = true

	setup_palette()
	setup_files()
	setup_grep()
	setup_terminal()
	setup_buffers()
	setup_logs()
	setup_utils()

	setup_autocmds()

	if opts.cfilter then
		util.packadd("cfilter")
	end

	vim.g["float_preview#docked"] = false

	winpick.setup({
		label_func = function(label)
			return label
		end,
	})
end

return M
