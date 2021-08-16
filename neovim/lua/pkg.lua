local function setup(mod)
	local path = string.format("pkg.%s", mod)
	local ok, fn_or_err = pcall(require, path)
	if ok then
		fn_or_err()
	else
		print(string.format("[pkg.lua] %s couldn't be loaded: %s", path, fn_or_err))
	end
end

local function set_colorscheme(theme)
	vim.cmd(string.format("colorscheme %s", theme))
end

local function paq_load()
	local paq = require("paq-nvim")

	paq({
		"savq/paq-nvim",

		-- Dependencies
		-- "nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"rktjmp/lush.nvim",

		-- Theming
		"famiu/feline.nvim",
		"npxbr/gruvbox.nvim",

		-- UX
		"mhinz/vim-startify",
		"moll/vim-bbye",
		-- "blackCauldron7/surround.nvim",
		"machakann/vim-sandwich",
		"kevinhwang91/nvim-bqf",
		"folke/which-key.nvim",
		"lewis6991/gitsigns.nvim",
		"akinsho/nvim-bufferline.lua",
		{
			"RRethy/vim-hexokinase",
			run = "make hexokinase",
		},

		-- Coding
		"editorconfig/editorconfig-vim",
		"hrsh7th/nvim-compe",
		"hrsh7th/vim-vsnip",
		"hrsh7th/vim-vsnip-integ",
		"neovim/nvim-lspconfig",
		{
			"nvim-treesitter/nvim-treesitter",
			run = function()
				vim.cmd("TSUpdate")
			end,
		},
		"lewis6991/spellsitter.nvim",
		"trsdln/vim-grepper",
		"voldikss/vim-floaterm",
		"folke/lua-dev.nvim",
		"mfussenegger/nvim-dap",
		"rcarriga/nvim-dap-ui",
		{
			"iamcco/markdown-preview.nvim",
			run = "cd app && yarn install",
		},
	})

	setup("vim_startify")
	setup("which_key")
	setup("nvim_lspconfig")
	setup("nvim_treesitter")
	setup("spellsitter")
	setup("nvim_compe")
	setup("vim_vsnip")
	setup("gitsigns_nvim")
	setup("vim_floaterm")
	setup("nvim_dap")
	setup("nvim_bufferline")
	setup("feline_nvim")
	setup("nvim_bqf")
	setup("gruvbox")
	set_colorscheme("gruvbox")
end

-- Install paq-nvim if not installed already.
if not pcall(require, "paq-nvim") then
	vim.cmd(
		'!git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim'
	)
	vim.cmd("packadd paq-nvim")
end

paq_load()
