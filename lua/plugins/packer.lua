Load 'packer'.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'single' }
    end,
  },
  autoremove = true,
}
