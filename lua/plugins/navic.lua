local navic = Load 'nvim-navic'
navic.setup {
  lsp = { auto_attach = true },
  highlight = true,
}

_G.get_winbar = function()
  -- show only the first $num_cont contexts
  local source = navic.get_location()
  local num_cont = 3
  local col

  -- find the column where the $num_cont context ends
  for _ = 1, num_cont do
    col = (source:find('%%#NavicSeparator#', col) or 0) + 1
  end

  col = col - 2 -- don't count first chars of pattern

  -- add default winbar
  local a = vim.api
  local buftype = a.nvim_buf_get_option(a.nvim_get_current_buf(), 'buftype')

  if buftype == 'help' or buftype == 'nofile' then
    return source:sub(1, col) .. '%#Normal# %<%=%* %t '
  end
  return source:sub(1, col) .. '%#Normal# %<%=%(%* %y%f%m%r%) '
end

vim.opt.winbar = "%{%v:lua.get_winbar()%}"
