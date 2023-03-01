Load 'nvim-tree'.setup {
  sync_root_with_cwd = true,
  on_attach = function(bufnr)
    local api = Load 'nvim-tree.api'
    Load 'core.utils'.set_maps({
      ['<Space>'] = api.node.open.edit
    }, { buffer = bufnr })
  end
}
