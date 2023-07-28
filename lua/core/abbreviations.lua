local abbr = {
  -- doc
  ['man'] = 'vert Man',
  ['h'] = 'vert h',
}
for k, v in pairs(abbr) do
  vim.cmd(string.format('cabbrev %s %s', k, v))
end
