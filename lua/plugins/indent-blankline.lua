Load'indent_blankline'.setup {
  char = "",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
  space_char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
  show_trailing_blankline_indent = false,
}
Load'core.utils'.set_g {
  indent_blankline_filetype_exclude = vim.list_extend(
    vim.g.indent_blankline_filetype_exclude,
    { "lisp", "yuck", "markdown" }),
}
