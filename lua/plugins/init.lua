local fn = vim.fn

-- Bootstrapping
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstraped
if fn.empty(fn.glob(install_path)) > 0 then
  vim.print 'Cloning packer...'
  is_bootstraped = fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  vim.cmd 'packadd packer.nvim'
end

local packer = Load 'packer'
Load 'plugins.packer' -- Packer config

-- Plugins
return packer.startup(function(use)
  -- Must have
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'lewis6991/impatient.nvim' -- improve startup time
  use 'tpope/vim-repeat'

  -- Terminal
  use {
    'numToStr/FTerm.nvim', --simple float term
    config = function()
      Load 'plugins.FTerm'
    end,
  }
  --use 'akinsho/toggleterm.nvim' --more complex terminal

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function()
      Load 'plugins.lsp.lspconfig'
    end,
  }
  use {
    'name-snrl/null-ls.nvim', -- TODO replace by upstream, when PR will be merged
    config = function()
      Load 'plugins.lsp.null-ls'
    end,
  }
  use 'scalameta/nvim-metals'
  use {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      Load('fidget').setup {}
    end,
  }

  -- Complete
  --use {
  --  'hrsh7th/nvim-cmp', -- TODO
  --  requires = {
  --    'hrsh7th/cmp-nvim-lsp',
  --    'saadparwaiz1/cmp_luasnip',
  --    'hrsh7th/cmp-nvim-lua',
  --    'hrsh7th/cmp-buffer',
  --    'hrsh7th/cmp-path',
  --    'hrsh7th/cmp-cmdline',
  --    --'hrsh7th/cmp-omni',
  --    "onsails/lspkind-nvim", -- vscode-like pictograms
  --  },
  --  config = function() Load'plugins.cmp' end,
  --}
  --use "L3MON4D3/LuaSnip"              -- snippet engine
  --use "rafamadriz/friendly-snippets"  -- a bunch of snippets to use
  use {
    'windwp/nvim-autopairs',
    config = function()
      Load 'plugins.autopairs'
    end,
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      Load 'plugins.treesitter'
    end,
    requires = {
      'HiPhish/nvim-ts-rainbow2',
    },
  }

  -- Text processing
  use {
    'kylechui/nvim-surround',
    config = function()
      Load('nvim-surround').setup()
    end,
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
      Load 'plugins.comment'
    end,
  }
  -- Cool plugin to replace text on project (rg+sed).
  -- You might need it someday.
  --use 'nvim-pack/nvim-spectre'

  -- Navigation
  use {
    'ThePrimeagen/harpoon',
    config = function()
      Load('harpoon').setup()
    end,
  }
  use 'famiu/bufdelete.nvim'
  use {
    'andymass/vim-matchup', -- TODO set up
    config = function()
      Load 'plugins.matchup'
    end,
  }
  use {
    'ggandor/leap.nvim',
    config = function()
      Load 'plugins.leap'
    end,
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'jvgrootveld/telescope-zoxide',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      Load 'plugins.telescope'
    end,
  }
  use {
    'SmiteshP/nvim-navic',
    config = function()
      Load 'plugins.navic'
    end,
  }
  --use 'SmiteshP/nvim-navbuddy' TODO

  -- Appearance
  use {
    'EdenEast/nightfox.nvim',
    config = function()
      Load 'plugins.nightfox-colorscheme'
    end,
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      Load 'plugins.indent-blankline'
    end,
  }

  -- Misc
  use 'NvChad/nvim-colorizer.lua'
  use {
    'uga-rosa/translate.nvim',
    config = function()
      Load 'plugins.translate'
    end,
  }
  use {
    'toppair/peek.nvim',
    run = 'deno task --quiet build:fast',
    commit = '13736cf0d9e9da4d53cef8abc4f4c34a7e22268e', -- TODO
  }
  -- TODO replace with https://github.com/microsoft/vscode-markdown-languageservice
  use {
    'name-snrl/mkdnflow.nvim',
    config = function()
      Load 'plugins.mkdnflow'
    end,
  }
  use {
    'elkowar/yuck.vim',
    config = function()
      Load 'plugins.yuck'
    end,
  }
  -- related:
  -- https://github.com/neovim/neovim/issues/3344
  -- https://github.com/neovim/neovim/issues/20672
  use {
    'ojroques/nvim-osc52',
    config = function()
      Load 'plugins.ssh_clipboard'
    end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if is_bootstraped then
    packer.sync()
  end
end)
