local tel_built = Load 'telescope.builtin'
local tel = Load 'telescope'
local hr_ui = Load 'harpoon.ui'
local toggle_or_jump = function()
  if vim.v.count == 0 then
    hr_ui.toggle_quick_menu()
  else
    hr_ui.nav_file(vim.v.count)
  end
end

-- a b c d e f g h i j k l m n o p q r s t u v w x y z
--
-- Keys used in combination with:
--
--      GLOBAL
-- Leader    -- b c e f g j n q u z
-- <C-\>     -- c f o t
-- gb
-- gc
-- gl
-- gs
-- gw
-- mn
--
--      LOCAL
-- Leader    -- b c f g j q u z
-- <C-\>     -- c f t
-- gs
-- gw
-- mn
--
--    Comment.nvim
-- gb
-- gc
-- gl
--
-- p.s. Leader is only used in n, x mode. <C-\> can be used in any mode

Load 'core.utils'.set_maps {
  [{ 'n', 'x' }] = {
    { 'mn',        Load 'harpoon.mark'.add_file },
    { 'gw',        toggle_or_jump },

    { '<Leader>z', tel.extensions.zoxide.list },
    { '<Leader>u', tel.extensions.undo.undo },
    { '<Leader>q', tel_built.diagnostics },
    { '<Leader>b', tel_built.buffers },
    { '<Leader>g', tel_built.live_grep },
    { '<Leader>j', function() tel_built.jumplist({ fname_width = 999 }) end },
    { '<Leader>f', function() tel_built.find_files({ follow = true }) end },

    { '<Leader>c', '<Cmd>ColorizerReloadAllBuffers<CR>' },

    { '<Del>', function()
      if vim.bo.modified then
        vim.cmd 'write | Bdelete'
      else
        vim.cmd 'Bdelete'
      end
      vim.cmd 'quit'
    end },
    { '<BS>', function()
      if vim.bo.modified then
        vim.cmd 'write | Bdelete'
      else
        vim.cmd 'Bdelete'
      end
    end },
  },

  [{ 'n', 'x', 'o' }] = {
    { 'gs', function() Load 'leap'.leap { target_windows = { vim.api.nvim_get_current_win() } } end },
  },

  [{ 'n', 'x', 'i', 't' }] = {
    { '<C-\\>c', '<Cmd>ColorizerToggle<CR>' },
  },

  [{ 'n', 't' }] = {
    { '<C-\\>t', Load("FTerm").toggle },
  },

  [{ 'i', 'x' }] = {
    { '<C-\\>t', '<Esc><Cmd>lua Load("FTerm").toggle()<CR>' },
  },
}
