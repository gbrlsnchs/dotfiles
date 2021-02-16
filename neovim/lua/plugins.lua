require('utils.packer').bootstrap()

return require('packer').startup(function()
  use(require('specs.packer'))

  --- Navigation
  use(require('specs.startify'))
  use(require('specs.fzf'))

  use {
    'nvim-lua/completion-nvim',
    opt = true,
    requires = {
      {'hrsh7th/vim-vsnip', opt = true},
      {'hrsh7th/vim-vsnip-integ', opt = true},
    },
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
  use(require('specs.lspconfig'))

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
