-- if $TERM:match('linux') then
local base = Load'base16-colorscheme'
local color_scheme = 'dark'

base.setup(color_scheme, { telescope = false } )

-- Copy-paste
local HEX_DIGITS = {
    ['0'] = 0,
    ['1'] = 1,
    ['2'] = 2,
    ['3'] = 3,
    ['4'] = 4,
    ['5'] = 5,
    ['6'] = 6,
    ['7'] = 7,
    ['8'] = 8,
    ['9'] = 9,
    ['a'] = 10,
    ['b'] = 11,
    ['c'] = 12,
    ['d'] = 13,
    ['e'] = 14,
    ['f'] = 15,
    ['A'] = 10,
    ['B'] = 11,
    ['C'] = 12,
    ['D'] = 13,
    ['E'] = 14,
    ['F'] = 15,
}
local function hex_to_rgb(hex)
    return HEX_DIGITS[string.sub(hex, 1, 1)] * 16 +  HEX_DIGITS[string.sub(hex, 2, 2)],
        HEX_DIGITS[string.sub(hex, 3, 3)] * 16 +  HEX_DIGITS[string.sub(hex, 4, 4)],
        HEX_DIGITS[string.sub(hex, 5, 5)] * 16 +  HEX_DIGITS[string.sub(hex, 6, 6)]
end
local function rgb_to_hex(r, g, b)
  return bit.tohex(bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b), 6)
end
local function darken(hex, pct)
    pct = 1 - pct
    local r, g, b = hex_to_rgb(string.sub(hex, 2))
    r = math.floor(r * pct)
    g = math.floor(g * pct)
    b = math.floor(b * pct)
    return string.format("#%s", rgb_to_hex(r, g, b))
end

-- Fix.

local hl = base.highlight

local cl = base.colorschemes[color_scheme]

local darkerbg = darken(cl.base00, 0.1)
local darker02 = darken(cl.base02, 0.1)

hl.WinSeparator       = { guifg = cl.base02, }
hl.Conditional        = { guifg = cl.base0E, guibg = nil, gui = 'bold', guisp = nil }
hl.TSConditional      = { guifg = cl.base0E, guibg = nil, gui = 'bold', guisp = nil }
hl.TSKeywordFunction  = { guifg = cl.base0E, guibg = nil, gui = 'bold', guisp = nil }
hl.Repeat             = { guifg = cl.base0A, guibg = nil, gui = 'bold', guisp = nil }
hl.TSRepeat           = { guifg = cl.base0A, guibg = nil, gui = 'bold', guisp = nil }


hl.TSTitle         = { guifg = 'none', gui = 'bold' }
hl.TSEmphasis      = { guifg = 'none', gui = 'italic' }
hl.TSURI           = { guifg = cl.base0D, gui = 'italic' }
hl.TSTextReference = { guifg = cl.base0D }
hl.TSStringEscape  = { guifg = cl.base03 }
hl.TSPunctSpecial  = { guifg = cl.base08 }

hl.TelescopeBorder       = { guifg = darker02,  guibg = darkerbg }
hl.TelescopeNormal       = { guifg = nil,       guibg = darkerbg }
hl.TelescopeSelection    = { guifg = cl.base08, gui = 'bold' }

hl.LeapBackdrop       = { guifg = cl.base03 }
hl.LeapMatch          = { guifg = cl.base0C, gui = 'bold' }
--hl.LeapLabelPrimary   = { guifg = cl.base0A, guibg = cl.base00}
--hl.LeapLabelSecondary = { guifg = cl.base08, guibg = cl.base00}
hl.LeapLabelPrimary   = { guifg = cl.base0A }
hl.LeapLabelSecondary = { guifg = cl.base08 }
hl.LeapLabelSelected  = { guifg = cl.base09 }

hl.IndentBlanklineIndent1 = { guibg = cl.base01, gui = 'nocombine' }
hl.IndentBlanklineIndent2 = { guibg = cl.base00, gui = 'nocombine' }

hl.rainbowcol1 = { guifg = cl.base0A }
hl.rainbowcol2 = { guifg = cl.base08 }
hl.rainbowcol3 = { guifg = cl.base09 }
hl.rainbowcol4 = { guifg = cl.base0D }
hl.rainbowcol5 = { guifg = cl.base0C }
hl.rainbowcol6 = { guifg = cl.base0E }
hl.rainbowcol7 = { guifg = cl.base0F }

vim.g.terminal_color_0  = cl.base00
vim.g.terminal_color_1  = '#d36265'
vim.g.terminal_color_2  = '#88ce7c'
vim.g.terminal_color_3  = '#e7e18c'
vim.g.terminal_color_4  = '#5297cf'
vim.g.terminal_color_5  = '#bf6ea3'
vim.g.terminal_color_6  = '#5baebf'
vim.g.terminal_color_7  = cl.base05
vim.g.terminal_color_8  = cl.base03
vim.g.terminal_color_9  = '#d36265'
vim.g.terminal_color_10 = '#88ce7c'
vim.g.terminal_color_11 = '#e7e18c'
vim.g.terminal_color_12 = '#5297cf'
vim.g.terminal_color_13 = '#bf6ea3'
vim.g.terminal_color_14 = '#5baebf'
vim.g.terminal_color_15 = cl.base07
