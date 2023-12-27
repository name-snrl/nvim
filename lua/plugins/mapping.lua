local tel_built = Load 'telescope.builtin'
local tel = Load 'telescope'
local hr = Load 'harpoon'
local toggle_or_jump = function()
  if vim.v.count == 0 then
    hr.ui:toggle_quick_menu(hr:list())
  else
    hr:list():select(vim.v.count)
  end
end

Load('core.utils').set_maps {
  [{ 'n', 'x' }] = {
    { 'mn', function() hr:list():append() end },
    { 'gw', toggle_or_jump },

    { '<Leader>z', tel.extensions.zoxide.list },
    { '<Leader>u', tel.extensions.undo.undo },
    { '<Leader>q', tel_built.diagnostics },
    { '<Leader>b', tel_built.buffers },
    { '<Leader>g', tel_built.live_grep },
    {
      '<Leader>j',
      function()
        tel_built.jumplist { fname_width = 999 }
      end,
    },
    {
      '<Leader>f',
      function()
        tel_built.find_files { follow = true }
      end,
    },

    {
      '<Del>',
      function()
        if vim.bo.modified then
          vim.cmd 'write | Bdelete'
        else
          vim.cmd.Bdelete()
        end
        vim.cmd.quit()
      end,
    },
    {
      '<BS>',
      function()
        if vim.bo.modified then
          vim.cmd 'write | Bdelete'
        else
          vim.cmd.Bdelete()
        end
      end,
    },

    { '<Leader>c', '<Cmd>ColorizerReloadAllBuffers<CR>' },
    { '<Leader>t', '<Cmd>Translate RU<CR>' },
    { '<Leader>e', '<Cmd>Translate EN -parse_before=trim,concat -output=insert<CR>' },
    { '<Leader>r', '<Cmd>Translate RU -parse_before=trim,concat -output=insert<CR>' },
  },

  n = {
    {
      '<Leader>w',
      function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd.norm { 'viw', bang = true }
        vim.cmd.Translate 'RU'
        vim.cmd.norm { 'v', bang = true }
        vim.api.nvim_win_set_cursor(0, pos)
      end,
    },
    { 'gce', '<Cmd>Translate EN -comment -parse_before=trim,concat -output=insert<CR>' },
    { 'gcr', '<Cmd>Translate RU -comment -parse_before=trim,concat -output=insert<CR>' },
  },

  [{ 'n', 'x', 'o' }] = {
    {
      'gs',
      function()
        Load('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
      end,
    },
  },

  [{ 'n', 'x', 'i', 't' }] = {
    { '<C-\\>c', '<Cmd>ColorizerToggle<CR>' },
  },

  [{ 'n', 't' }] = {
    { '<C-\\>t', Load('FTerm').toggle },
  },

  [{ 'i', 'x' }] = {
    { '<C-\\>t', '<Esc><Cmd>lua Load("FTerm").toggle()<CR>' },
  },
}
