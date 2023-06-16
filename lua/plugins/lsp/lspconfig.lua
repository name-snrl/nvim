Load 'plugins.lsp.sumneko'
Load 'plugins.lsp.metals'
Load 'plugins.lsp.nil'

local servers = {
  'bashls',
}

for _, server in pairs(servers) do
  Load('lspconfig')[server].setup { on_attach = Load 'plugins.lsp.basics'.on_attach }
end
