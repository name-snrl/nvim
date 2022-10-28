local M = {}

M.set_opts = function (options)
  for k, v in pairs(options) do
    if tostring(v):match('^+=') then
      -- append
      vim.opt[k]:append(v:gsub('+=', ''))

    elseif tostring(v):match('^%^=') then
      -- prepend
      vim.opt[k]:prepend(v:gsub('%^=', ''))

    elseif tostring(v):match('^-=') then
      -- remove
      vim.opt[k]:remove(v:gsub('-=', ''))

    else
      vim.opt[k] = v
    end
  end
end

M.set_opts_local = function (options)
  for k, v in pairs(options) do
    if tostring(v):match('^+=') then
      -- append
      vim.opt_local[k]:append(v:gsub('+=', ''))

    elseif tostring(v):match('^%^=') then
      -- prepend
      vim.opt_local[k]:prepend(v:gsub('%^=', ''))

    elseif tostring(v):match('^-=') then
      -- remove
      vim.opt_local[k]:remove(v:gsub('-=', ''))

    else
      vim.opt_local[k] = v
    end
  end
end

M.set_maps = function (mapping, arg1, arg2)

  -- Valid mapping formats:
  --
  --local mapping = {
  --  [{ 'n', 'x', 'i', 't' }] = {
  --    { lhs, rhs, opts },
  --  },
  --}
  --
  -- OR
  --
  --local mapping = {
  --  ['<C-a>'] = rhs,
  --  qw = rhs,
  --}

  local modes
  local options

  if arg1 and ( arg1[1] or type(arg1) == 'string' ) then
    modes = arg1
    options = arg2
  else
    modes = arg2
    options = arg1
  end

  for key, value in pairs(mapping) do
    if type(value) == "table" then
      local mode = key
      local tbl = value

      for _, v in pairs(tbl) do
        local lhs = v[1]
        local rhs = v[2]

        local opts = options or {}
        if v[3] then
          opts = vim.tbl_deep_extend('keep', v[3], opts)
        end

        vim.keymap.set(mode, lhs, rhs, opts)
      end
    else
      local mode = modes or {'n', 'x'}
      local lhs = key
      local rhs = value

      vim.keymap.set(mode, lhs, rhs, options)
    end
  end
end

M.set_hls = function (hls)
  for name, val in pairs(hls) do
    vim.api.nvim_set_hl(0, name, val)
  end
end

M.create_autocmds = function (cmds, opts)
  for events, lopts in pairs(cmds) do
    if opts then
      lopts = vim.tbl_deep_extend('keep', lopts, opts)
    end
    if type(lopts.group) == 'string' then
      lopts.group = vim.api.nvim_create_augroup(lopts.group, { clear = false })
    end
    vim.api.nvim_create_autocmd(events, lopts)
  end
end

M.set_g = function(globals)
  for k, v in pairs(globals) do
    vim.g[k] = v
  end
end

return M
