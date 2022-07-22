Load'lspconfig'.ltex.setup {
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = vim.tbl_deep_extend(
          'force',
          vim.diagnostic.config().virtual_text,
          { format = function() return '' end }
        )
      }
    )
  },
  settings = {
    ltex = {
      diagnosticSeverity = 'hint'
    }
  }
}
