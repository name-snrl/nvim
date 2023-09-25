local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim
    .system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
    :wait()
end
vim.opt.rtp:prepend(lazypath)

Load('lazy').setup {
  -- Must have
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  'kyazdani42/nvim-web-devicons',
  'tpope/vim-repeat',

  -- Terminal
  {
    'numToStr/FTerm.nvim', --simple float term
    config = function()
      Load 'plugins.FTerm'
    end,
  },
  --use 'akinsho/toggleterm.nvim' --more complex terminal

  -- LSP
  {
    'neovim/nvim-lspconfig',
    config = function()
      Load 'plugins.lsp.lspconfig'
    end,
  },
  {
    'name-snrl/null-ls.nvim', -- TODO replace by upstream, when PR will be merged
    config = function()
      Load 'plugins.lsp.null-ls'
    end,
  },
  'scalameta/nvim-metals',
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      Load('fidget').setup {}
    end,
  },

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
  {
    'windwp/nvim-autopairs',
    config = function()
      Load 'plugins.autopairs'
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      Load 'plugins.treesitter'
    end,
    dependencies = {
      'HiPhish/nvim-ts-rainbow2',
    },
  },

  -- Text processing
  {
    'kylechui/nvim-surround',
    config = function()
      Load('nvim-surround').setup()
    end,
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      Load 'plugins.comment'
    end,
  },
  -- Cool plugin to replace text on project (rg+sed).
  -- You might need it someday.
  --use 'nvim-pack/nvim-spectre'

  -- Navigation
  {
    'ThePrimeagen/harpoon',
    config = function()
      Load('harpoon').setup()
    end,
  },
  'famiu/bufdelete.nvim',
  {
    'andymass/vim-matchup', -- TODO set up
    config = function()
      Load 'plugins.matchup'
    end,
  },
  {
    'ggandor/leap.nvim',
    config = function()
      Load 'plugins.leap'
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'jvgrootveld/telescope-zoxide',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      Load 'plugins.telescope'
    end,
  },
  {
    'SmiteshP/nvim-navic',
    config = function()
      Load 'plugins.navic'
    end,
  },
  --use 'SmiteshP/nvim-navbuddy' TODO

  -- Appearance
  {
    'EdenEast/nightfox.nvim',
    config = function()
      Load 'plugins.nightfox-colorscheme'
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      Load 'plugins.indent-blankline'
    end,
  },

  -- Misc
  'NvChad/nvim-colorizer.lua',
  {
    'uga-rosa/translate.nvim',
    config = function()
      Load 'plugins.translate'
    end,
  },
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    commit = '13736cf0d9e9da4d53cef8abc4f4c34a7e22268e', -- TODO
  },
  -- TODO replace with https://github.com/microsoft/vscode-markdown-languageservice
  {
    'name-snrl/mkdnflow.nvim',
    config = function()
      Load 'plugins.mkdnflow'
    end,
  },
  {
    'elkowar/yuck.vim',
    config = function()
      Load 'plugins.yuck'
    end,
  },
  -- related:
  -- https://github.com/neovim/neovim/issues/3344
  -- https://github.com/neovim/neovim/issues/20672
  {
    'ojroques/nvim-osc52',
    config = function()
      Load 'plugins.ssh_clipboard'
    end,
  },
}
