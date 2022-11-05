--[[
# Indents

Simple rules:
1. Don't mix tabs and spaces.
2. Don't use tabs for text alignment.

Summury from :h tabstop

When spaces prefer:

  tabstop = 8,     -- default value
  softtabstop = 0, -- default value
  shiftwidth = 2,
  expandtab = true,

When tabs prefer(tabstop and shiftwidth should be the same value):

  tabstop = 2,
  softtabstop = 0, -- default value
  shiftwidth = 2,
  expandtab = false,

Note: If text alignment was done with tabs and with a different tabstop value,
it may break the indentations.
]]
local indents = {
  -- Spaces
  [{ 'sh', 'rust', 'python' }] = {
    tabstop = 8,
    softtabstop = 0,
    shiftwidth = 4,
    expandtab = true,
  },
  [{ 'nix', 'lua', 'vim', 'css', 'json', 'yaml', 'markdown' }] = {
    tabstop = 8,
    softtabstop = 0,
    shiftwidth = 2,
    expandtab = true,
  },
  -- Tabs
  [{ 'go' }] = {
    tabstop = 4,
    softtabstop = 0,
    shiftwidth = 4,
    expandtab = false,
  },
  --[{  }] = {
  --  tabstop = 2,
  --  softtabstop = 0,
  --  shiftwidth = 2,
  --  expandtab = false,
  --},
}

for ft, opts in pairs(indents) do
  Load 'core.utils'.create_autocmds {
    FileType = {
      pattern = ft,
      callback = function() Load 'core.utils'.set_opts(opts) end,
      group = 'core.indents'
    }
  }
end
