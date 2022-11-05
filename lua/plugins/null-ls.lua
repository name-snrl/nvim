local b = Load 'null-ls.builtins'
Load 'null-ls'.setup {
  sources = {
    b.diagnostics.shellcheck,
    b.code_actions.shellcheck,
  },
}
