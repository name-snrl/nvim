-- Sources config files.
-- Yes, without using require(). We don't need to cache config modules
vim.cmd.runtime { args = { 'cfg_modules/**/*.lua' }, bang = true }

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim
    .system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
    :wait()
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = 'plugins',
  defaults = { lazy = true },
}
