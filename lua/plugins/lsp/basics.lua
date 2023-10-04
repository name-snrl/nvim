local telescope = Load 'telescope.builtin'

local M = {}

M.mapping = function(bufnr)
  Load('core.utils').set_maps({
    [{ 'n', 'x' }] = {
      { 'cx', vim.lsp.buf.code_action },
    },
    n = {
      { 'gD', vim.lsp.buf.declaration },
      { 'gd', telescope.lsp_definitions },
      { 'K', vim.lsp.buf.hover },
      { 'gi', telescope.lsp_implementations },
      --{ '<C-k>', vim.lsp.buf.signature_help },
      --{ '<Leader>wa', vim.lsp.buf.add_workspace_folder },
      --{ '<Leader>wr', vim.lsp.lsp.remove_workspace_folder },
      --{ '<Leader>wl', function() vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end },
      { 'dz', telescope.lsp_type_definitions },
      { 'cv', vim.lsp.buf.rename },
      { 'gr', telescope.lsp_references },
      { 'gq', vim.lsp.buf.format },
    },
  }, { buffer = bufnr })
end

M.on_attach = function(client, bufnr)
  M.mapping(bufnr)
end

return M
