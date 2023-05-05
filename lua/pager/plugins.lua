local o = vim.opt

o.loadplugins = false -- do not load plugins

-- the plugins we need
o.runtimepath:append '~/.local/share/nvim/site/pack/*/start/nightfox.nvim'
o.runtimepath:append '~/.local/share/nvim/site/pack/*/start/nvim-colorizer.lua'
o.runtimepath:append '~/.local/share/nvim/site/pack/*/start/leap.nvim'
vim.cmd 'runtime plugin/man.lua'
vim.cmd 'runtime plugin/netrwPlugin.vim'
vim.cmd 'runtime plugin/colorizer.vim'
Load 'plugins.nightfox-colorscheme'
Load 'plugins.leap'
Load 'core.utils'.set_maps {
  [{ 'n', 'x', 'o' }] = {
    { 'gs', function() Load 'leap'.leap { target_windows = { vim.api.nvim_get_current_win() } } end },
  },
}
