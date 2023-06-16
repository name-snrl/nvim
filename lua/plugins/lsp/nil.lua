Load('lspconfig').nil_ls.setup {
  settings = {
    ['nil'] = {
      formatting = {
        command = { 'nixpkgs-fmt' },
      },
      nix = {
        flake = { autoArchive = true },
      },
    },
  },
  on_attach = Load('plugins.lsp.basics').on_attach,
}
