local np = require 'nvim-autopairs'
local rl = require 'nvim-autopairs.rule'

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

-- TODO set-up better autopair for markdown
np.add_rules {
  rl('_', '_', 'markdown')
    :with_move(function(opts)
      local count = 0
      for _ in opts.text:gmatch('_') do
        count = count + 1
      end
      if count == 3 and #opts.text > 3 then
        return true
      end
      return false
    end),

  rl('__', '__', 'markdown')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('._') ~= nil
    end)
    :use_key('_'),

  rl('*', '*', 'markdown')
    :with_move(function(opts)
      local count = 0
      for _ in opts.text:gmatch('*') do
        count = count + 1
      end
      if count == 3 and #opts.text > 3 then
        return true
      end
      return false
    end),

  rl('**', '**', 'markdown')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%*') ~= nil
    end)
    :use_key('*'),

  rl('$', '$', 'markdown')
    :with_move(function(opts)
      local count = 0
      for _ in opts.text:gmatch('%$') do
        count = count + 1
      end
      if count == 3 and #opts.text > 3 then
        return true
      end
      return false
    end),

  rl('$$', '$$', 'markdown')
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%$') ~= nil
    end)
    :use_key('$'),
  rl(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '$$' }, pair)
    end),
  rl('$ ', ' $')
      :with_pair(function() return false end)
      :replace_endpair(function(opts)
        if opts.line:sub(opts.col + 1):match('^%$') then
          return ' $$'
        else
          return ' $'
        end
      end)
      :with_move(function(opts)
          return opts.prev_char:match('.%$') ~= nil
      end)
      :use_key('$'),
}
