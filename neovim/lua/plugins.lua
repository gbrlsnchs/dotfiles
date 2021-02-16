require('utils.packer').bootstrap()

return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}

  --- Navigation
  use 'mhinz/vim-startify'
  use 'junegunn/fzf.vim'

  --- LSP
  use {
    'neovim/nvim-lspconfig',
    opt = true,
  }
  use {
    'nvim-lua/completion-nvim',
    opt = true,
    requires = {
      {'hrsh7th/vim-vsnip', opt = true},
      {'hrsh7th/vim-vsnip-integ', opt = true},
    },
  }
  use {
    'ojroques/nvim-lspfuzzy',
    opt = true,
    requires = {
      {'junegunn/fzf.vim'},
    },
    config = function()
      require('config.lspfuzzy')
    end,
    cond = function()
      return require('utils.lsp').is_enabled()
    end,
  }

  --- Git
  -- I'm trying to move to neovim-remote with integrated terminal.
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = [[require('config.gitsigns')]],
  }

  --- Utils
  use 'moll/vim-bbye'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'tpope/vim-sleuth'
  use 'lambdalisue/suda.vim'
  use {
    'RRethy/vim-hexokinase',
    run = 'make hexokinase',
  }
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = {'markdown', 'plantuml'},
    cmd = 'MarkdownPreview',
    config = function()
      vim.g.mkdp_filetypes = {'markdown', 'plantuml'}
    end,
  }
  use {
    'itchyny/lightline.vim',
    requires = {
      {'itchyny/vim-gitbranch'},
    },
  }
  use 'spinks/vim-leader-guide'
  use 'dstein64/nvim-scrollview'

  --- Syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    opt = true,
    run = ':TSUpdate',
  }
  use 'editorconfig/editorconfig-vim'
  use {
    'https://github.com/aklt/plantuml-syntax',
    config = function()
      vim.g.plantuml_set_makepr = false
    end,
  }

  --- Theme
  use 'arcticicestudio/nord-vim'
end)
