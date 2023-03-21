Load 'lspconfig'.metals.setup {
  root_dir = Load 'lspconfig.util'.root_pattern(
    'WORKSPACE',
    'build.sbt',
    'build.sc',
    'build.gradle',
    'pom.xml'),
  on_attach = function(_, bufnr)
    local mapping = Load 'plugins.lspconfig.mapping'
    Load 'core.utils'.set_maps(mapping, 'n', { buffer = bufnr })
  end
}
