local fn = vim.fn

-- Bootstrapping
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstraped
if fn.empty(fn.glob(install_path)) > 0 then
  print 'Cloning packer...'
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


  -- Terminals
  use {
    'numToStr/FTerm.nvim', --simple float term
    config = function() Load 'plugins.FTerm' end,
  }
  --use 'akinsho/toggleterm.nvim' --more complex terminal


  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function() Load 'plugins.lspconfig' end,
  }
  --use {
  --  'jose-elias-alvarez/null-ls.nvim',
  --  config = function() Load'plugins.null-ls' end,
  --}
  --use 'RishabhRD/nvim-lsputils'
  --use 'folke/lua-dev.nvim'
  --use 'folke/trouble.nvim'
  --use 'ray-x/lsp_signature.nvim'


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
    config = function() Load 'plugins.autopairs' end,
  }


  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
    config = function() Load 'plugins.treesitter' end,
    requires = {
      'HiPhish/nvim-ts-rainbow2',
      'nvim-treesitter/playground',
    },
  }


  -- Text processing
  use 'Vonr/align.nvim' -- TODO set up
  use {
    'kylechui/nvim-surround',
    config = function() Load 'nvim-surround'.setup() end,
  }
  --use {
  --  'numToStr/Comment.nvim', -- TODO
  --  config = function()
  --    require('Comment').setup()
  --  end
  --}


  -- Navigation
  --use 'ThePrimeagen/harpoon' -- if alternate or marks are not enough
  use 'moll/vim-bbye'
  -- TODO set up and start to use plugins above
  --use 'simnalamburt/vim-mundo'  -- undotree navigation, try this first
  --use 'mbbill/undotree'         -- undotree navigation
  use {
    'andymass/vim-matchup', -- TODO set up
    config = function() Load 'plugins.matchup' end,
  }
  use {
    'ggandor/leap.nvim',
    config = function() Load 'plugins.leap' end,
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'jvgrootveld/telescope-zoxide',
    },
    config = function() Load 'plugins.telescope' end,
  }
  use {
    'kyazdani42/nvim-tree.lua',
    config = function() Load 'plugins.nvim-tree' end,
  }


  -- Appearance
  use {
    'b0o/incline.nvim',
    config = function() Load 'plugins.incline' end,
  }
  use {
    'EdenEast/nightfox.nvim',
    config = function() Load 'plugins.nightfox-colorscheme' end,
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function() Load 'plugins.indent-blankline' end,
  }


  -- Misc
  use 'norcalli/nvim-colorizer.lua'
  use {
    'elkowar/yuck.vim',
    config = function() Load 'plugins.yuck' end,
  }
  use {
    'ojroques/nvim-osc52',
    config = function() Load 'plugins.ssh_clipboard' end,
  }
  --use 'tpope/vim-obsession'                   -- auto :mksession
  --use 'antoinemadec/FixCursorHold.nvim'       -- not sure I need this


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if is_bootstraped then
    packer.sync()
  end
end)
