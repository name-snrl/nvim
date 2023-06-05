local abbr = {
  -- doc
  ['man'] = 'vert Man',
  ['sman'] = 'Man',
  ['h'] = 'vert h',
  ['sh'] = 'h',
  ['help'] = 'vert help',
}
for k, v in pairs(abbr) do
  vim.cmd(string.format('cabbrev %s %s', k, v))
end
