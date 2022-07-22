Load'core.mapping'
nvimpager.maps = false -- disable default mapping
vim.g.no_man_maps = '' -- disable man mapping

-- autoload/man.vim sets the mapping for q, here we remap it
Load'core.utils'.create_autocmds {
  FileType = {
    group = 'NvimPager',
    pattern = 'man',
    command = 'nn <buffer> q <Cmd>qa!<CR>',
  }
}

Load'core.utils'.set_maps {
  ['<Leader>c'] = '<Cmd>ColorizerReloadAllBuffers<CR>',
  ['<C-\\>c']   = '<Cmd>ColorizerToggle<CR>',
  ['<C-w>]']    = '<C-w>v<C-]>',

  q = '<Cmd>qa!<CR>',
  j = 'gj',
  k = 'gk',
}
