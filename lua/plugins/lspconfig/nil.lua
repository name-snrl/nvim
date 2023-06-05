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
  on_attach = function(_, bufnr)
    local mapping = Load 'plugins.lspconfig.mapping'
    Load('core.utils').set_maps(mapping, 'n', { buffer = bufnr })
  end,
}
