--[[
# Modes

The modes I use:
- normal mode  = 'n',
- visual mode  = 'x',
- insert mode  = 'i',
- command mode = 'c',
- ins+cmd mode = '!',
- term mode    = 't',

# All posible default {motion}'s that used with operators:
- a b e f g h i j k l t w

# Some tricks
'stty -ixon' to disable flow control and unbind C-q and C-s in tty
btw C-_(read C-/) is another great key sequence

Use <unique> to check the existing mapping. e.g.:
  :map <unique> n k

Use '<Cmd>...<CR>' instead ':...<CR>'
  :h <Cmd>
]]

local utils = Load'core.map_utils'
local rec_opts = { remap = true } -- :h recursive_mapping

-- a b c d e f g h i j k l m n o p q r s t u v w x y z
--
-- Keys used in combination with:
--
--      GLOBAL
-- Leader    -- b c e f g j q z /
-- <C-\>     -- c f o t
--
--      LOCAL
-- Leader    -- e
-- <C-\>     --
--
-- p.s. Leader is only used in n, x mode. <C-\> can be used in any mode

Load'core.utils'.set_maps {
  [{ 'n', 'x', 'i', 't' }] = {
    -- Submode for plugins, except C-\ e in command mode
    { '<C-q>', '<C-\\>', rec_opts },
  },

  [{ 'n', 'x' }] = {

    -- Standard sequences* that are not used or duplicate other keys.
    -- * only sequences that work in tty
    --
    -- GLOBAL   -- LOCAL
    --          --      -- +
    --          --      -- -
    --          --      -- _
    -- used     -- used -- <F1> - <F12>
    -- used     -- used -- <Down>
    -- used     -- used -- <Left>
    -- used     -- used -- <Right>
    -- used     -- used -- <Up>
    --          --      -- <End>
    --          --      -- <Home>
    --          --      -- <PageUp>
    --          --      -- <PageDown>
    -- used     --      -- <Del>        -- plugins.mapping
    -- used     --      -- <BS>         -- plugins.mapping
    -- used     -- used -- <Space>
    --          --      -- <Insert>
    --                  -- C-h
    -- used     -- used -- C-j
    -- used     -- used -- C-k
    --          --      -- C-m
    -- used     -- used -- C-n
    --          --      -- C-p
    -- used     -- used -- C-q
    --          --      -- C-s
    -- used     -- used -- C-_ == C-/ == C-&
    --
    -- p.s. Alt free to use.

    { '<Space>', '<Leader>', rec_opts },

    -- Do not overwrite the register when using the change operator
    { 's', '"_s' },
    { 'c', '"_c' },
    { 'C', '"_C' },

    -- Marks
    { "`", "'" },
    { "'", "`" },

    -- move the cursor with the screen when scrolling
    { '<C-e>', utils.scroll_down },
    { '<C-y>', utils.scroll_up },

    -- Buffers managment
    { '<C-j>', utils.prev_buf_arg },
    { '<C-k>', utils.next_buf_arg },
    { '<C-_>',      '<C-^>' }, -- swap to alternate
    { '<C-w>/',     '<Cmd>vsp #<CR>' },       -- alternate to a split window
    { '<C-w><C-_>', '<Cmd>tab split #<CR>' }, -- alternate to a new tab
    { '<C-w>f',     '<Cmd>vsp <cfile><CR>' }, -- the same as the default, but in the vertical split

    -- Windows managment
    { '<Left>',  '<C-w>h' },
    { '<Down>',  '<C-w>j' },
    { '<Up>',    '<C-w>k' },
    { '<Right>', '<C-w>l' },
    { '<C-w>t',  '<C-w>T' },

    -- Tabs managment
    { 'gt',    '<Cmd>tabnew<CR>' },
    { '<M-j>', '<Cmd>+tabmove<CR>' },
    { '<M-k>', '<Cmd>-tabmove<CR>' },
    { '<M-i>', 'gT' },
    { '<M-o>', 'gt' },
    { '<F1>',  '1gt' },
    { '<F2>',  '2gt' },
    { '<F3>',  '3gt' },
    { '<F4>',  '4gt' },
    { '<F5>',  '5gt' },
    { '<F5>',  '5gt' },
    { '<F6>',  '6gt' },
    { '<F7>',  '7gt' },
    { '<F8>',  '8gt' },
    { '<F9>',  '9gt' },
    { '<F10>', '10gt' },
    { '<F11>', '11gt' },
    { '<F12>', '12gt' },

    -- Diagnostic
    { '<Leader>e', vim.diagnostic.open_float },
    { '[d', vim.diagnostic.goto_prev },
    { ']d', vim.diagnostic.goto_next },

    { '<C-n>', '<Cmd>%s///gn<CR>' }, -- print the number of matches
  },

  ['n'] = {
    -- Scrolling for term-mode
    { '<S-PageUp>',   '<C-u>0M' },
    { '<S-PageDown>', '<C-d>0M' },
  },

  ['x'] = {
    -- Do not yank word that you replace with your clipboard
    { 'p', 'P' },
    { 'P', 'p' },

    -- Better indenting
    { '<', '<gv' },
    { '>', '>gv' },
  },

  ['i'] = {
    -- Standard sequences that are not used or duplicate other keys.
    --
    -- GLOBAL   -- LOCAL
    --          --      -- C-_ == C-/ == C-&
    --          --      -- C-b
    --          --      -- C-l
    --          --      -- C-h
    --          --      -- C-j
    --   used   -- used -- C-q
    --          --      -- C-s
    --
    -- Standard sequences that I find useless.
    --
    -- GLOBAL   -- LOCAL
    --          --      -- C-e
    --          --      -- C-k
    --          --      -- C-n
    --          --      -- C-p
    --          --      -- C-y
    --
    -- p.s. Alt free to use.
  },

  ['t'] = {
    -- Scrolling
    { '<S-PageUp>',     '<C-\\><C-n><C-u>0M' },
    { '<S-PageDown>',   '<C-\\><C-n><C-d>0M' },
  },
}
