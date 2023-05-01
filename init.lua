_G.Load = function(path)
  local ok, mod = pcall(require, path)
  if not ok then
    print('Error loading module ' .. path)
    print(mod)
  else
    return mod
  end
end

vim.opt.runtimepath:prepend((vim.env.XDG_CONFIG_HOME or '~/.config') .. '/nvim')

Load 'impatient'
Load 'core.options'
Load 'core.mapping'
Load 'core.autocmds'
Load 'core.indents'
Load 'core.abbreviations'
Load 'core.g_variables'
Load 'core.lsp'
Load 'core.diagnostic'
Load 'core.tabline'
Load 'plugins'
Load 'plugins.mapping'
Load 'test'
