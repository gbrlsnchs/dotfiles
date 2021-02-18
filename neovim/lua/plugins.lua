require('utils.packer').bootstrap()

return require('packer').startup(function()
	use(require('specs.packer'))
	use(require('specs.startify'))
	use(require('specs.fzf'))
	use(require('specs.lspconfig'))
	use(require('specs.compe'))
	use(require('specs.gitsigns'))
	use(require('specs.leader_guide'))
	use 'moll/vim-bbye'
	use 'tpope/vim-surround'
	use 'tpope/vim-commentary'
	use 'tpope/vim-sleuth'
	use 'lambdalisue/suda.vim'
	use(require('specs.hexokinase'))
	use(require('specs.markdown_preview'))
	use(require('specs.lightline'))
	use 'dstein64/nvim-scrollview'
	use(require('specs.treesitter'))
	use 'editorconfig/editorconfig-vim'
	use {
		'https://github.com/aklt/plantuml-syntax',
		config = function()
			vim.g.plantuml_set_makepr = false
		end,
	}
	use {'gbrlsnchs/nord-vim', branch = 'fix-neovim-lsp'}
end)
