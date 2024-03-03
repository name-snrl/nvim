for option_name, value in pairs {
  mouse = '',
  clipboard = 'unnamedplus',
  timeout = false,

  -- appearance
  cursorline = true,
  signcolumn = 'yes',
  list = true,
  listchars = 'tab:▸ ',
  linebreak = true,

  -- folding
  foldmethod = 'expr',
  foldexpr = 'v:lua.vim.treesitter.foldexpr()',

  -- ins-completion
  pumheight = 10,
  completeopt = 'menu,menuone,longest,noselect',

  -- cmdline-completion
  --
  -- The first press (longest:full) completes the longest common string and
  -- opens wildmenu, if there is no common string, just opens wildmenu. On
  -- the second press (full), complete the next full match.
  wildmode = 'longest:full,full',
  wildignorecase = true,

  -- search
  wrapscan = false,
  ignorecase = true,
  smartcase = true,

  -- scrolloff
  scrolloff = 3,
  sidescrolloff = 15,

  -- marks
  jumpoptions = 'view',

  -- split
  splitbelow = true,
  splitright = true,

  -- undo
  undofile = true,
  undolevels = 5000,

  -- indents
  shiftwidth = 2,
  expandtab = true,
} do
  vim.opt[option_name] = value
end
