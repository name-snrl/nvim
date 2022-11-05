-- motions: a b e f g h i j k l t w
-- free: d m n o p q r s u x y z

local lsp = vim.lsp.buf
local tel = Load 'telescope.builtin'
return {
  gd = tel.lsp_definitions,
  gi = tel.lsp_implementations,
  gr = tel.lsp_references,
  gD = lsp.declaration,
  K  = lsp.hover,
  cv = lsp.rename,
  gw = lsp.format,
  --['<C-k>']     = lsp.signature_help,
  --['<Leader>D']  = lsp.type_definition,
  --['<Leader>ca'] = lsp.code_action,
  --['<Leader>wa'] = lsp.add_workspace_folder,
  --['<Leader>wr'] = lsp.remove_workspace_folder,
  --['<Leader>wl'] = function()
  --  print(vim.inspect(lsp.list_workspace_folders()))
  --end,
}
