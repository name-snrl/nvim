Load 'plugins.lspconfig.sumneko'
Load 'plugins.lspconfig.metals'
Load 'plugins.lspconfig.nil'

local servers = {
  'bashls',
}

for _, server in pairs(servers) do
  Load 'lspconfig'[server].setup {
    on_attach = function(_, bufnr)
      local mapping = Load 'plugins.lspconfig.mapping'
      Load 'core.utils'.set_maps(mapping, 'n', { buffer = bufnr })
    end,
  }
end
