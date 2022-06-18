local winpick = require("winpick")

local excmd = require("me.api.excmd")
local session = require("me.api.session")
local db = require("me.api.db")
local oldfiles = require("me.api.oldfiles")
local util = require("me.api.util")
local palette = require("me.cfg.editor.palette")
local files = require("me.cfg.editor.files")
local grep = require("me.cfg.editor.grep")
local terminal = require("me.cfg.editor.terminal")
local buffers = require("me.cfg.editor.buffers")
local utils = require("me.cfg.editor.utils")
local logs = require("me.cfg.editor.logs")

local api = vim.api

local augroup = api.nvim_create_augroup("editor", {})

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
		FindRecentFiles = {
			desc = "Find files that were opened recently",
			callback = function()
				files.find_oldfiles()
			end,
			opts = {
				keymap = { keys = "<Leader>fo" },
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

local function track_oldfiles(project_name)
	api.nvim_create_autocmd("BufWinEnter", {
		group = augroup,
		pattern = "?*",
		callback = function()
			oldfiles.upsert_hits(project_name)
		end,
	})
end

--- Sets up automatic commands.
local function setup_autocmds()
	api.nvim_create_autocmd("BufReadPost", {
		group = augroup,
		pattern = "*",
		command = "silent! lcd .",
	})
	api.nvim_create_autocmd("TextYankPost", {
		group = augroup,
		pattern = "*",
		callback = function()
			vim.highlight.on_yank()
		end,
	})
	api.nvim_create_autocmd("TermOpen", {
		group = augroup,
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
		group = augroup,
	})

	api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		once = true,
		callback = function()
			local project_name = session.get_option("project_name")
			if not project_name then
				vim.notify("Skipping setup of oldfiles due to missing project name", vim.log.levels.WARN)
				return true
			end

			local ok = oldfiles.init(project_name)

			if ok then
				track_oldfiles(project_name)
			end

			return true
		end,
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
		format_label = function(label)
			return label
		end,
	})
end

return M
