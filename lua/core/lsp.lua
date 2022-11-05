local lsp_h = vim.lsp.handlers

lsp_h['textDocument/hover'] = vim.lsp.with(
  lsp_h.hover, {
  border = 'rounded',
  close_events = {
    'CursorMoved',
    'CursorMovedI',
    'InsertCharPre',
    'ModeChanged'
  },
  focusable = false,
}
)

lsp_h['textDocument/signatureHelp'] = vim.lsp.with(
  lsp_h.signature_help, {
  border = 'rounded',
  close_events = {
    'CursorMoved',
    'CursorMovedI',
    'InsertCharPre',
    'ModeChanged'
  },
}
)
