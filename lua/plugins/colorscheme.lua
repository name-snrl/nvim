-- selene: allow(mixed_table)
return {
  'EdenEast/nightfox.nvim',
  init = function()
    vim.cmd.colorscheme 'nordfox'
  end,
  opts = {
    options = {
      styles = {
        comments = 'italic',
        conditionals = 'bold',
        functions = 'italic',
        keywords = 'bold',
      },
      inverse = { match_paren = true },
    },
    palettes = {
      nordfox = {
        bg0 = '#242b32', -- -3 lightless
        bg1 = '#2b323b', -- hue 212 saturation 16 lightless 20
        bg2 = '#38424d', -- +6 lightless
        bg3 = '#45515f', -- +6 lightless
        bg4 = '#516070', -- +6 lightless
      },
    },
    groups = {
      all = {
        WinBar = { link = 'StatusLine' },
        WinBarNC = { link = 'StatusLineNC' },
        CursorLine = { bg = 'bg2' },
        Comment = { fg = 'bg4' },
        EndOfBuffer = { link = 'NonText' }, -- show end of buffer
      },
    },
  },
}
