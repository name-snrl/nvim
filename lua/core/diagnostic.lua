--[[
Overriding virtual_text handler.

Adds new feature 'align'.

Can be a bool or a number. A number is the deviation.
e.g., if deviation = 2 (default), then lines 3, 4, 5 or
3, 5, 7 will have the same indent, but 3, 6 will not.
--]]
if not vim.env.TERM:match('linux') then
  local signs = {
    Error = "",
    Warn  = "",
    Info  = "",
    Hint  = "",
  }

  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

vim.diagnostic.config({
  underline = true,
  virtual_text = {
    prefix = '*',
    align = true,
  },
  signs = true,
  float = {
    header = '',
    source = 'always',
    prefix = '',
    --
    close_events = {
      'CursorMoved',
      'CursorMovedI',
      'InsertCharPre',
      'ModeChanged'
    },
    focusable = true,
    --
    style = 'minimal',
    border = 'single',
  },
  update_in_insert = true,
  severity_sort = true,
})
