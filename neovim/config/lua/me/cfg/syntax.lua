local util = require("me.api.util")

local M = {}

--- Sets up filetypes.
--- @param filetypes table: List of custom filetypes.
local function setup_filetypes(filetypes)
	-- NOTE: Remove these after support for filetype.lua is official.
	vim.g.did_load_filetypes = 0
	vim.g.do_filetype_lua = 1

	vim.filetype.add(util.tbl_merge(filetypes, {
		extension = {
			gcfg = "dosini",
		},
		pattern = {
			[".*/srcpkgs/.*/template"] = "sh", -- Void Linux templates.
			[".*/river/.*/init"] = "sh",
		},
	}))
end

--- Sets up tree-sitter core and its extensions.
--- @param opts table: List of custom filetypes.
local function setup_tree_sitter(opts)
	if not opts.enabled then
		return
	end

	util.packadd("nvim-treesitter")

	local ts = require("nvim-treesitter.configs")
	local ts_parsers = require("nvim-treesitter.parsers")

	local settings = {
		highlight = { enable = true },
		indent = { enable = true },
	}

	if opts.rainbow then
		util.packadd("nvim-ts-rainbow")

		local palette = require("me.cfg.colorscheme.palette")

		settings.rainbow = {
			enable = true,
			extended_mode = true,
			max_file_lines = nil,
			colors = {
				palette.bright_red,
				palette.bright_green,
				palette.bright_blue,
				palette.bright_cyan,
				palette.bright_purple,
				palette.bright_yellow,
				palette.yellow,
			},
		}
	end

	if opts.auto_tagging then
		util.packadd("nvim-ts-autotag")

		settings.autotag = {
			enable = true,
			filetypes = {
				"html",
				"javascript",
				"javascriptreact",
				"typescriptreact",
				"svelte",
				"vue",
				"xml",
			},
		}
	end

	if opts.spelling then
		util.packadd("spellsitter.nvim")
		local spellsitter = require("spellsitter")

		spellsitter.setup()
	end

	if opts.commentstring then
		util.packadd("nvim-ts-context-commentstring")
		settings.context_commentstring = {
			enable = true,
		}
	end

	util.packadd("tree-sitter-just")

	local parsers_dir = vim.fn.stdpath("data") .. "/site/parsers"
	local parsers_config = ts_parsers.get_parser_configs()

	parsers_config.just = {
		install_info = {
			url = parsers_dir .. "/tree-sitter-just",
			files = { "src/parser.c", "src/scanner.cc" },
		},
	}

	ts.setup(settings)

	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end

--- Sets up hex code coloring.
--- @param is_active boolean: Whether the feature is active.
local function setup_colorizer(is_active)
	if not is_active then
		return
	end

	util.packadd("nvim-colorizer.lua")
	local colorizer = require("colorizer")

	colorizer.setup()
end

function M.setup(opts)
	opts = util.tbl_merge(opts, {
		tree_sitter = {
			enabled = true,
			rainbow = true,
			auto_tagging = true,
			spelling = true,
			commentstring = true,
		},
		filetypes = nil, -- project's custom filetypes
		colorizer = true,
	})

	setup_filetypes(opts.filetypes)
	setup_tree_sitter(opts.tree_sitter)
	setup_colorizer(opts.colorizer)
end

return M
