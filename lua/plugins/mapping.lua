local tel_built = Load'telescope.builtin'
local tel = Load'telescope'

-- a b c d e f g h i j k l m n o p q r s t u v w x y z
--
-- Keys used in combination with:
--
--      GLOBAL
-- Leader    -- b c e f g j m q z /
-- <C-\>     -- c f o t
--
--      LOCAL
-- Leader    -- b c f g j m q z /
-- <C-\>     -- c f t
--
-- p.s. Leader is only used in n, x mode. <C-\> can be used in any mode

Load'core.utils'.set_maps {
  [{ 'n', 'x' }] = {

    { '<Leader>z', tel.extensions.zoxide.list },
    { '<Leader>q', tel_built.diagnostics },
    { '<Leader>m', tel_built.marks },
    { '<Leader>b', tel_built.buffers },
    { '<Leader>/', tel_built.current_buffer_fuzzy_find },
    { '<Leader>g', tel_built.live_grep },
    { '<Leader>j', function() tel_built.jumplist({ fname_width = 999 }) end },
    { '<Leader>f', function() tel_built.find_files({ follow = true }) end },

    { '<Leader>c', '<Cmd>ColorizerReloadAllBuffers<CR>' },

    { '<Del>', '<Cmd>write<bar>Bdelete<CR><Cmd>q<CR>' },
    { '<BS>',  '<Cmd>write<bar>Bdelete<CR>' },
  },

  [{ 'n', 'x', 'o' }] = {
    { 'f', function() Load 'leap'.leap { inclusive_op = true } end },
    { 'F', function() Load 'leap'.leap { backward = true } end },
    { 't', function() Load 'leap'.leap { inclusive_op = true, offset = -1 } end },
    { 'T', function() Load 'leap'.leap { backward = true, offset = 1 } end },
    -- TODO implement the behavior of the builin ; and ,
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
