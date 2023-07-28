local f_name = 'core.autocmds.'

Load('core.utils').create_autocmds {
  CmdlineEnter = {
    group = f_name .. 'wildmenu',
    callback = function()
      vim.opt.smartcase = false
    end,
  },
  CmdlineLeave = {
    group = f_name .. 'wildmenu',
    callback = function()
      vim.opt.smartcase = true
    end,
  },
}
