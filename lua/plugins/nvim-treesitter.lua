-- selene: allow(mixed_table)
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  main = 'nvim-treesitter.configs',
  opts = { highlight = { enable = true } },
}
