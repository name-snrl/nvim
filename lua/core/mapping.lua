--[[
# Modes I use

- normal mode  = 'n',
- visual mode  = 'x',
- insert mode  = 'i',
- command mode = 'c',
- ins+cmd mode = '!',
- term mode    = 't',

# Some tricks
'stty -ixon' to disable flow control and unbind C-q and C-s in tty
btw C-_(read C-/) is another great key sequence

Use <unique> to check the existing mapping. e.g.:
  :map <unique> n k

Use '<Cmd>...<CR>' instead ':...<CR>'
  :h <Cmd>

---------------------------------------------------

# List of unused or unimportant sequences and their status

A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

## Global:

Alt free to use.

<C-\> + c o t


## Normal and Visual modes

Combination of operators and motions.  I plan to use them mostly for lsp. Keys
that are not {motion}'s:

c d m n o p q r s u v x y z

Thus, you can make any combination starting with an :operator and ending with
any of the above buttons. Exceptions are mappings like `cc`.

___

     - +
     - -
     - _
used - <F1> - <F12>
used - <Down>
used - <Left>
used - <Right>
used - <Up>
     - <End>
     - <Home>
     - <PageUp>
     - <PageDown>
used - <Del>
used - <BS>
used - <Space>
     - <Insert>
     - C-h
used - C-j
used - C-k
     - C-m
used - C-n
     - C-p
used - C-q
     - C-s
used - C-_ == C-/ == C-&

___

You may also find something useless in sequences beginning with z/g. I'll just
list what I use:

gb
gc
gl
gs
gw
mn

___

<Leader> + b c e f g j q r t u z


## Insert mode

     - C-_ == C-/ == C-&
     - C-b
     - C-l
     - C-h
     - C-j
used - C-q
     - C-s

Standard sequences that I find useless:

     - C-e
     - C-k
     - C-n
     - C-p
     - C-y
]]
local utils = Load 'core.map_utils'
local rec_opts = { remap = true }

Load('core.utils').set_maps {
  [{ 'n', 'x', 'i', 't' }] = {
    -- Submode for plugins, except C-\ e in command mode
    { '<C-q>', '<C-\\>', rec_opts },
  },

  [{ 'n', 'x' }] = {

    { '<Space>', '<Leader>', rec_opts },

    { 'gf', '<Cmd>e <cfile><CR>' }, -- open even if file doesn't exist

    -- Do not overwrite the register when using the change operator
    { 's', '"_s' },
    { 'c', '"_c' },
    { 'C', '"_C' },

    -- Marks
    { '`', "'" },
    { "'", '`' },

    -- move the cursor with the screen when scrolling
    { '<C-e>', utils.scroll_down },
    { '<C-y>', utils.scroll_up },

    -- Buffers managment
    { '<C-j>', utils.prev_buf_arg },
    { '<C-k>', utils.next_buf_arg },
    { '<C-_>', '<C-^>' }, -- swap to alternate
    { '<C-/>', '<C-^>' }, -- repeat for foot
    { '<C-w>/', '<Cmd>vsp #<CR>' }, -- alternate to a split window
    { '<C-w><C-_>', '<Cmd>tab split #<CR>' }, -- alternate to a new tab
    { '<C-w><C-/>', '<Cmd>tab split #<CR>' }, -- repeat for foot
    { '<C-w>f', '<Cmd>vsp <cfile><CR>' }, -- the same as the default, but in the vertical split

    -- Windows managment
    { '<Left>', '<C-w>h' },
    { '<Down>', '<C-w>j' },
    { '<Up>', '<C-w>k' },
    { '<Right>', '<C-w>l' },
    { '<C-w>t', '<C-w>T' },

    -- Tabs managment
    { 'gt', '<Cmd>tabnew<CR>' },
    { '<M-j>', '<Cmd>+tabmove<CR>' },
    { '<M-k>', '<Cmd>-tabmove<CR>' },
    { '<M-i>', 'gT' },
    { '<M-o>', 'gt' },
    { '<F1>', '1gt' },
    { '<F2>', '2gt' },
    { '<F3>', '3gt' },
    { '<F4>', '4gt' },
    { '<F5>', '5gt' },
    { '<F5>', '5gt' },
    { '<F6>', '6gt' },
    { '<F7>', '7gt' },
    { '<F8>', '8gt' },
    { '<F9>', '9gt' },
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
    { '<S-PageUp>', '<C-u>0M' },
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

  ['i'] = {},

  ['t'] = {
    -- Scrolling
    { '<S-PageUp>', '<C-\\><C-n><C-u>0M' },
    { '<S-PageDown>', '<C-\\><C-n><C-d>0M' },
  },
}
