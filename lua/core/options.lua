Load'core.utils'.set_opts {
  fileencodings = 'ucs-bom,utf-8,default,cp1251,latin1',
  fileencoding = 'utf-8',

  timeout = false,
  clipboard = '+=unnamedplus',

  -- appearance
  cursorline = true,
  laststatus = 3,
  list = true,
  listchars = 'tab: ━❯',
  linebreak = true,

  -- ins-completion
  pumheight = 10,
  completeopt = 'menu,menuone,longest,noselect',

  -- cmdline-completion
  wildmode = 'longest:full,full',
  wildignorecase = true,

  -- number/sign columns
  relativenumber = true,
  signcolumn = 'yes',
  numberwidth = 2,

  -- search
  wrapscan = false,
  ignorecase = true,
  smartcase = true,

  -- scrolloff
  scrolloff = 3,
  sidescrolloff = 10,

  -- marks
  jumpoptions = 'view',

  -- split
  splitbelow = true,
  splitright = true,

  -- undo
  undofile = true,
  undolevels = 5000,

  -- indents
  autoindent = true,
  --smartindent = true,
  tabstop = 8,     -- default value
  softtabstop = 0, -- default value
  shiftwidth = 2,
  expandtab = true,
}
