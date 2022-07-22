_G.Load = function (path)
  local ok, mod = pcall(require, path)
  if not ok then
    print('Error loading module ' .. path)
    print(mod)
  else
    return mod
  end
end

vim.opt.runtimepath:prepend(
  ( vim.env.XDG_CONFIG_HOME or '~/.config' ) ..
  '/nvim'
)

do -- use colors from difftool
  local cmd = 'cat /proc/' .. vim.env.PARENT .. '/cmdline'
  if vim.fn.system(cmd):match('difftool') then
    nvimpager.git_colors = true
  end
end

Load'pager.options'
Load'pager.mapping'
Load'pager.plugins'
Load'pager.autocmds'
Load'core.abbreviations'
Load'core.g_variables'
