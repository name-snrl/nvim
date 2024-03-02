vim.keymap.set({ 'n', 'x' }, '<Space>', '<Leader>', { remap = true })

-- normal and select modes
for lhs, rhs in pairs {
  -- stylua: ignore
  ['gf'] = function() vim.cmd.edit '<cfile>' end, -- open even if file doesn't exist
  -- stylua: ignore
  ['<C-w>f'] = function() vim.cmd.vsplit '<cfile>' end, -- the same as the default, but in the vertical split

  -- do not overwrite the register when using the change operator
  ['s'] = '"_s',
  ['c'] = '"_c',
  ['C'] = '"_C',

  -- Marks
  ["''"] = '\'"', -- I don't use ''

  -- Buffers managment
  ['<C-j>'] = vim.cmd.bnext,
  ['<C-k>'] = vim.cmd.bprev,
  ['<C-_>'] = '<C-^>', -- swap to alternate
  ['<C-/>'] = '<C-^>', -- repeat for foot
  -- stylua: ignore
  ['<C-w>/'] = function() vim.cmd.vsp '#' end, -- alternate to a split window

  -- Windows managment
  ['<Left>'] = '<C-w>h',
  ['<Down>'] = '<C-w>j',
  ['<Up>'] = '<C-w>k',
  ['<Right>'] = '<C-w>l',

  -- Diagnostic
  ['<Leader>d'] = vim.diagnostic.open_float,
  ['[d'] = vim.diagnostic.goto_prev,
  [']d'] = vim.diagnostic.goto_next,

  -- print the number of matches
  ['<C-n>'] = function()
    vim.notify(vim.fn.searchcount({ maxcount = 0 }).total .. ' matches')
  end,
} do
  vim.keymap.set({ 'n', 'x' }, lhs, rhs)
end

-- select mode
for lhs, rhs in pairs {
  -- do not yank word that you replace with your clipboard
  p = 'P',
  P = 'p',

  -- better indenting
  ['<'] = '<gv',
  ['>'] = '>gv',
} do
  vim.keymap.set('x', lhs, rhs)
end
