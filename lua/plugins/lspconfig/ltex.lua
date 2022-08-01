Load'lspconfig'.ltex.setup {
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
      }
    )
  },
  settings = {
    ltex = {
      diagnosticSeverity = 'hint'
    }
  }
}
