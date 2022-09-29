local config = require("me.api.config")

local opts = config.get("editor", "treesitter")

if not opts.enabled then
	return
end

local util = require("me.api.util")

util.packadd("nvim-treesitter")
util.packadd("nvim-treesitter-textobjects")

local ts = require("nvim-treesitter.configs")
local ts_parsers = require("nvim-treesitter.parsers")

local settings = {
	highlight = { enable = true },
	indent = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["]a"] = "@parameter.inner",
			},
			swap_previous = {
				["[a"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		lsp_interop = {
			enable = false,
		},
	},
}

if opts.rainbow then
	util.packadd("nvim-ts-rainbow")

	local palette = require("me.cfg.colorscheme.palette")

	settings.rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
		colors = {
			palette.red,
			palette.green,
			palette.blue,
			palette.cyan,
			palette.purple,
			palette.yellow,
			palette.gray,
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

if opts.context then
	util.packadd("nvim-treesitter-context")
	local ctx = require("treesitter-context")

	ctx.setup()
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
