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
        'WHITESPACE_RULE',
        '--text',
        '\\$TEXT', -- add a symbol to avoid the error when the text starts with a dash
      },
      diagnostics_postprocess = function(diagnostic)
        if diagnostic.lnum == 0 then
          diagnostic.col = diagnostic.col - 1
          diagnostic.end_col = diagnostic.end_col - 1
        end
        return diagnostic
      end,
      filetypes = { 'text', 'markdown', 'gitcommit' },
    },
  },
}