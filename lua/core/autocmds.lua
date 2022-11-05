local o = vim.opt
local f_name = 'core.autocmds.'

Load 'core.utils'.create_autocmds {
  CmdlineEnter = {
    group = f_name .. 'wildmenu',
    callback = function() o.smartcase = false end,
  },
  CmdlineLeave = {
    group = f_name .. 'wildmenu',
    callback = function() o.smartcase = true end,
  },
}
