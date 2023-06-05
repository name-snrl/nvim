local metals_config = require('metals').bare_config()
metals_config.settings = { useGlobalExecutable = true }
metals_config.on_attach = function(_, bufnr)
  local mapping = Load 'plugins.lspconfig.mapping'
  Load('core.utils').set_maps(mapping, 'n', { buffer = bufnr })
end
local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt', 'java' },
  callback = function()
    require('metals').initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
