local tel_built = Load 'telescope.builtin'
local tel = Load 'telescope'

-- a b c d e f g h i j k l m n o p q r s t u v w x y z
--
-- Keys used in combination with:
--
--      GLOBAL
-- Leader    -- b c e f g j m q u z /
-- <C-\>     -- c f o t
-- gb
-- gc
-- gl
-- gs
--
--      LOCAL
-- Leader    -- b c f g j m q u z /
-- <C-\>     -- c f t
-- gs
--
--    Comment.nvim
-- gb
-- gc
-- gl
--
-- p.s. Leader is only used in n, x mode. <C-\> can be used in any mode

Load 'core.utils'.set_maps {
  [{ 'n', 'x' }] = {

    { '<Leader>z', tel.extensions.zoxide.list },
    { '<Leader>u', tel.extensions.undo.undo },
    { '<Leader>q', tel_built.diagnostics },
    { '<Leader>m', tel_built.marks },
    { '<Leader>b', tel_built.buffers },
    { '<Leader>/', tel_built.current_buffer_fuzzy_find },
    { '<Leader>g', tel_built.live_grep },
    { '<Leader>j', function() tel_built.jumplist({ fname_width = 999 }) end },
    { '<Leader>f', function() tel_built.find_files({ follow = true }) end },

    { '<Leader>c', '<Cmd>ColorizerReloadAllBuffers<CR>' },

    { '<Del>', function()
      if vim.opt.ro:get() then
        vim.api.nvim_command 'Bdelete'
      else
        vim.api.nvim_command 'write | Bdelete'
      end
      vim.api.nvim_command 'quit'
    end },
    { '<BS>', function()
      if vim.opt.ro:get() then
        vim.api.nvim_command 'Bdelete'
      else
        vim.api.nvim_command 'write | Bdelete'
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
    { '<C-\\>f', '<Cmd>NvimTreeToggle<CR>' },
  },

  [{ 'i', 'x' }] = {
    { '<C-\\>t', '<Esc><Cmd>lua Load("FTerm").toggle()<CR>' },
    { '<C-\\>f', '<Esc><Cmd>NvimTreeToggle<CR>' },
  },
}
