Load('lspconfig').lua_ls.setup {
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
          vim.fn.stdpath 'config' .. '/init.lua',
        },
      },
      telemetry = {
        enable = false,
      },
      format = {
        enable = false,
      },
    },
  },
  on_attach = Load('plugins.lsp.basics').on_attach,
}
