Load 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'nvimpager', 'mp' },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME .. '/lua',
          vim.fn.stdpath('config') .. '/init.lua',
        },
      },
      telemetry = {
        enable = false,
      },
    }
  },
  on_attach = function(_, bufnr)
    local mapping = Load 'plugins.lspconfig.mapping'
    Load 'core.utils'.set_maps(mapping, 'n', { buffer = bufnr })
  end
}
