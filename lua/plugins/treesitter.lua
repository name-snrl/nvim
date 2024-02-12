Load('nvim-treesitter.configs').setup {
  ensure_installed = Load('core.utils').is_nix_package {
    yes = vim.opt.runtimepath:prepend(vim.g.nix_ts_parsers or ''),
    no = {
      'bash',
      'fish',
      'lua',
      'luap',
      'luadoc',
      'vim',
      'nix',
      'go',
      'c',
      'rust',
      'scala',
      'starlark',

      'css',
      'yaml',
      'markdown',
      'markdown_inline',
      'dockerfile',
    },
  },

  highlight = {
    enable = true,
    disable = function(_, bufnr)
      return vim.api.nvim_buf_line_count(bufnr) > 5000
    end,
  },

  --incremental_selection = {
  --  enable = true,
  --  keymaps = {
  --    init_selection = "gnn",
  --    node_incremental = "grn",
  --    scope_incremental = "grc",
  --    node_decremental = "grm",
  --  },
  --},

  --textobjects = {
  --  select = {
  --    enable = true,
  --    lookahead = true,
  --    lookbehind = true,
  --    keymaps = {
  --      ["aa"] = "@parameter.outer",
  --      ["ia"] = "@parameter.inner",
  --      ["ib"] = "@block.inner",
  --      ["ab"] = "@block.outer",
  --    },
  --  },
  --  move = {
  --    enable = true,
  --    goto_previous_start = {
  --      ["[b"] = "@block.outer",
  --    },
  --  },
  --},

  --rainbow = {
  --  enable = true,
  --  query = 'rainbow-parens',
  --  strategy = Load('ts-rainbow').strategy.global,
  --},
}
