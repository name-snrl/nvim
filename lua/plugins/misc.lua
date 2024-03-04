vim.g.deepl_api_auth_key = vim.trim(vim.secure.read(vim.fn.stdpath 'config' .. '/deepl_key'))

-- selene: allow(mixed_table)
return {
  {
    'uga-rosa/translate.nvim',
    opts = {
      default = { command = vim.g.deepl_api_auth_key and 'deepl_free' or 'google' },
      silent = true,
    },
    -- stylua: ignore
    keys = {
      { '<Leader>t', '<Cmd>Translate RU<CR>', mode = { 'n', 'x' } },
      { '<Leader>w', "<Cmd>exe 'norm! mtviwv' | '<,'>Translate RU<CR><Cmd>keepjumps norm! `t<CR>" },
      { '<Leader>e', '<Cmd>Translate EN -parse_after=no_handle -output=insert<CR>', mode = { 'n', 'x' }, },
      { '<Leader>r', '<Cmd>Translate RU -parse_after=no_handle -output=insert<CR>', mode = { 'n', 'x' }, },
    },
  },
  {
    'brenoprata10/nvim-highlight-colors',
    -- stylua: ignore
    keys = {
      { '<Leader>c', function() require('nvim-highlight-colors').toggle() end, },
    },
  },
}
