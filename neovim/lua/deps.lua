local packer_repo = "wbthomason/packer.nvim"

local common_deps = {
	plenary_nvim = "nvim-lua/plenary.nvim",
}

local aliases = {
	["gruvbox.nvim"] = "gruvbox",
	["lualine.nvim"] = "lualine",
	["nvim-cmp"] = "nvim-cmp",
	["nvim-lspconfig"] = "nvim-lsp",
	["nvim-treesitter"] = "nvim-treesitter",
	["which-key.nvim"] = "which-key",
}

local deps = {
	["bufdelete.nvim"] = "famiu/bufdelete.nvim",
	["editorconfig.nvim"] = "gpanders/editorconfig.nvim",
	["filename.nvim"] = "nathom/filetype.nvim",
	["fzf-lua"] = {
		"ibhagwan/fzf-lua",
		after = aliases["which-key.nvim"],
		requires = {
			{ "vijaymarupudi/nvim-fzf" },
		},
		config = require("deps.fzf_lua.config"),
	},
	["gitsigns.nvim"] = {
		"lewis6991/gitsigns.nvim",
		after = aliases["which-key.nvim"],
		requires = common_deps.plenary_nvim,
		config = require("deps.gitsigns_nvim.config"),
	},
	["gruvbox.nvim"] = {
		"ellisonleao/gruvbox.nvim",
		as = aliases["gruvbox.nvim"],
		requires = "rktjmp/lush.nvim",
		setup = require("deps.gruvbox_nvim.setup"),
		config = require("deps.gruvbox_nvim.config"),
	},
	["lualine.nvim"] = {
		"nvim-lualine/lualine.nvim",
		as = aliases["lualine.nvim"],
		after = {
			aliases["nvim-lspconfig"],
			aliases["nvim-treesitter"],
		},
		config = require("deps.lualine_nvim.config"),
		requires = "arkav/lualine-lsp-progress",
	},
	["winpick.nvim"] = "gbrlsnchs/winpick.nvim",
	["nvim-bqf"] = "kevinhwang91/nvim-bqf",
	["nvim-comment"] = {
		"terrortylor/nvim-comment",
		config = require("deps.nvim_comment.config"),
	},
	["nvim-cmp"] = {
		"hrsh7th/nvim-cmp",
		as = aliases["nvim-cmp"],
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{
				"hrsh7th/cmp-vsnip",
				requires = {
					{
						"hrsh7th/vim-vsnip",
						config = require("deps.vim_vsnip.config"),
					},
				},
			},
		},
		config = require("deps.nvim_cmp.config"),
	},
	["nvim-colorizer"] = {
		"norcalli/nvim-colorizer.lua",
		config = require("deps.nvim_colorizer.config"),
	},
	["nvim-fzf"] = {
		"vijaymarupudi/nvim-fzf",
		config = require("deps.nvim_fzf.config"),
	},
	["nvim-lspconfig"] = {
		"neovim/nvim-lspconfig",
		as = aliases["nvim-lspconfig"],
		after = {
			aliases["which-key.nvim"],
			aliases["nvim-cmp"],
		},
		requires = {
			{ "folke/lua-dev.nvim" },
			{ "nvim-lua/lsp-status.nvim" },
			{ "RRethy/vim-illuminate" },
		},
		config = require("deps.nvim_lspconfig.config"),
	},
	["nvim-treesitter"] = {
		"nvim-treesitter/nvim-treesitter",
		as = aliases["nvim-treesitter"],
		run = ":TSUpdate",
		after = aliases["gruvbox.nvim"],
		config = require("deps.nvim_treesitter.config"),
		requires = {
			{ "JoosepAlviste/nvim-ts-context-commentstring" },
			{ "p00f/nvim-ts-rainbow" },
			{ "windwp/nvim-ts-autotag" },
			{ "SmiteshP/nvim-gps" },
		},
	},
	["packer.nvim"] = packer_repo,
	["plenary.nvim"] = "nvim-lua/plenary.nvim",
	["spellsitter.nvim"] = {
		"lewis6991/spellsitter.nvim",
		after = aliases["nvim-treesitter"], -- Without this, it breaks tree-sitter...
		config = require("deps.spellsitter.config"),
	},
	["surround.nvim"] = {
		"blackCauldron7/surround.nvim",
		config = require("deps.surround_nvim.config"),
	},
	["vim-bettergrep"] = {
		"qalshidi/vim-bettergrep",
		config = require("deps.vim_bettergrep.config"),
	},
	["vim-oldfiles"] = "gpanders/vim-oldfiles",
	["vim-startify"] = {
		"mhinz/vim-startify",
		config = require("deps.vim_startify.config"),
	},
	["which-key.nvim"] = {
		"folke/which-key.nvim",
		as = aliases["which-key.nvim"],
		config = require("deps.which_key_nvim.config"),
	},
}

-- Install packer if not installed already.
local vim_fn = vim.fn

local install_path = ("%s/site/pack/packer/start/packer.nvim"):format(vim_fn.stdpath("data"))
local should_bootstrap = vim_fn.empty(vim_fn.glob(install_path)) > 0

if should_bootstrap then
	vim_fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		("https://github.com/%s.git"):format(packer_repo),
		install_path,
	})
	vim.cmd("packadd packer.nvim")
end

local packer = require("packer")
local packer_util = require("packer.util")
local config = {
	display = {
		open_fn = packer_util.float,
	},
}

packer.startup({
	function(use)
		-- Libraries.
		use(deps["plenary.nvim"])
		use(deps["nvim-fzf"])
		use(deps["winpick.nvim"])

		-- Themes.
		use(deps["gruvbox.nvim"])
		use(deps["lualine.nvim"])

		-- Package manager.
		use(deps["packer.nvim"])

		-- Keybinding helper.
		use(deps["which-key.nvim"])

		-- Completion.
		use(deps["nvim-cmp"])

		-- LSP.
		use(deps["nvim-lspconfig"])

		-- Git.
		use(deps["gitsigns.nvim"])

		-- Syntax.
		use(deps["nvim-treesitter"])
		use(deps["spellsitter.nvim"])

		-- Helpers.
		use(deps["nvim-bqf"])
		use(deps["vim-bettergrep"])
		use(deps["vim-startify"])
		-- use(deps["fzf-lua"])

		-- Utility.
		use(deps["editorconfig.nvim"])
		use(deps["bufdelete.nvim"])
		use(deps["filename.nvim"])
		use(deps["vim-oldfiles"])
		-- use(deps["surround.nvim"])
		use(deps["nvim-comment"])
		use(deps["nvim-colorizer"])
	end,
	config = config,
})

if should_bootstrap then
	packer.install()
	packer.compile()
end
