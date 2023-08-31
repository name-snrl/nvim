local b = Load 'null-ls.builtins'
Load('null-ls').setup {
  on_attach = function(client, bufnr)
    vim.keymap.set('n', 'gq', vim.lsp.buf.format, { buffer = bufnr })
  end,
  sources = {
    b.formatting.deno_fmt,
    b.formatting.stylua,
    b.formatting.shfmt.with {
      args = { '--case-indent', '--indent', '4', '$FILENAME' },
    },
    b.diagnostics.ltrs.with {
      args = {
        'check',
        '--raw',
        '--mother-tongue',
        'ru-RU',
        '--disabled-rules',
        'WHITESPACE_RULE,EN_UPPER_CASE_NGRAM',
        '--text',
        '$TEXT',
      },
      filetypes = { 'text', 'markdown', 'gitcommit' },
    },
  },
}
