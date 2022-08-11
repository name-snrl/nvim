local np = require 'nvim-autopairs'
local rl = require 'nvim-autopairs.rule'
local cond = require'nvim-autopairs.conds'

np.setup {
  disable_in_macro = true,
  ignored_next_char = '[%w%.]',
  map_c_w = true,
  fast_wrap = {
    map = '<C-g>e',
    chars = { '{', '[', '(', '"', "'" },
    pattern = [=[[%s%'%"%)%>%]%)%}%,]]=],
    end_key = 'e',
    keys = 'fjdkslwoia;vngh',
  },
}

np.add_rules {
  rl(' ', ' ', 'lua')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  rl('( ', ' )', 'lua')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key(')'),
  rl('{ ', ' }', 'lua')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%}') ~= nil
      end)
      :use_key('}'),
  rl('[ ', ' ]', 'lua')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%]') ~= nil
      end)
      :use_key(']')
}

-- TODO change the opening pairs from '_' to '^_' and ' _' so that the role is
-- only called after a space or at the beginning of a line.
np.add_rules {
  rl('_', '_', 'markdown')
    :with_move(function(opts)
      -- if prev char is not pair
      return opts.line:sub(opts.col - 1, opts.col - 1) ~= '_'
    end),

  rl('__', '__', 'markdown')
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.prev_char:match('._') ~= nil
    end),

  rl('*', '*', 'markdown')
    :with_move(function(opts)
      -- if prev char is not pair
      return opts.line:sub(opts.col - 1, opts.col - 1) ~= '*'
    end),

  rl('**', '**', 'markdown')
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.prev_char:match('.%*') ~= nil
    end),

  rl('$', '$', 'markdown')
    :with_move(function(opts)
      -- if prev char is not pair
      return opts.line:sub(opts.col - 1, opts.col - 1) ~= '$'
    end),

  rl('$$', '$$', 'markdown')
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.prev_char:match('.%$') ~= nil
    end),

  -- TODO set-up spaces between pairs for markdown
  -- so that it does not end other pairs with a space.

  --rl(' ', ' ', 'markdown')
  --  :with_pair(function(opts)
  --    local pair = opts.line:sub(opts.col -1, opts.col)
  --    return vim.tbl_contains({ '$$' }, pair)
  --  end)
  --  :with_move(cond.none())
  --  :with_cr(cond.none())
  --  :with_del(function(opts)
  --    local col = vim.api.nvim_win_get_cursor(0)[2]
  --    local context = opts.line:sub(col - 1, col + 2)
  --    return vim.tbl_contains({ '$  $' }, context)
  --  end),

  --rl('', ' $', 'markdown')
  --  :with_pair(cond.none())
  --  :with_move(function(opts) return opts.char == '$' end)
  --  :with_cr(cond.none())
  --  :with_del(cond.none())
  --  :use_key('$'),

  --rl('', ' $$', 'markdown')
  --  :with_pair(cond.none())
  --  :with_move(function(opts) return opts.char == '$' end)
  --  :with_cr(cond.none())
  --  :with_del(cond.none())
  --  :use_key('$'),
}
