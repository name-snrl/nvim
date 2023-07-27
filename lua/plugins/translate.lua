Load('core.utils').set_g {
  deepl_api_auth_key = vim.fn.readfile('/home/name_snrl/.config/nvim/deepl_key')[1],
}
Load('translate').setup {
  default = {
    command = 'deepl_free',
    output = 'floating',
  },
  silent = true,
}
