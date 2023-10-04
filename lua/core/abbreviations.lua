local abbr = {
  -- doc
  ['man'] = 'vert Man',
  ['h'] = 'vert h',
}
for k, v in pairs(abbr) do
  vim.cmd.cabbrev(string.format('%s %s', k, v))
end
