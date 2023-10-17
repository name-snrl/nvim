Load('core.utils').set_g {
  deepl_api_auth_key = vim.fn.readfile(vim.fn.stdpath 'config' .. '/deepl_key')[1],
}
Load('translate').setup {
  default = {
    command = 'deepl_free',
    output = 'floating',
  },
  silent = true,
}
