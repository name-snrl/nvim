Load'incline'.setup {
  window = {
    margin = { vertical = 0 },
    winhighlight = {
      active = { Normal = 'StatusLine' },
      inactive = { Normal = 'StatusLineNC' }
    },
  },
  ignore = {
    unlisted_buffers = false,
    buftypes = {
      'acwrite',
      'nowrite',
      'quickfix',
      'terminal',
      'prompt',
    },
    wintypes = {
      'autocmd',
      'command',
      'loclist',
      'popup',
      'preview',
      'quickfix',
      'unknown',
    }
  },
  render = function(props)
    -- TODO hide incline if the 1st bufline is too long and is on the screen
    local buf = props.buf
    local win = props.win
    local fn = vim.fn
    local a = vim.api
    local o = vim.opt_local

    local res
    local name = a.nvim_buf_get_name(buf)

    if a.nvim_buf_get_option(buf, 'buftype') == 'help' then
      return vim.fs.basename(name)
    elseif not a.nvim_buf_get_option(buf, 'buflisted') then
      return
    elseif a.nvim_buf_get_option(buf, 'buftype') == 'nofile'
      and name:match('man://')then
      return vim.fs.basename(name:gsub('man://', ''))
    elseif a.nvim_buf_get_option(buf, 'buftype') == 'nofile' then
      return
    elseif name ~= '' then
      res = vim.fn.fnamemodify(name, ':~:.')
    else
      res = '[No Name]'
    end

    local ft = a.nvim_buf_get_option(buf, 'filetype')
    if ft ~= '' then
      res = '[' .. ft .. ']' .. res
    end

    if a.nvim_buf_get_option(buf, 'modified') then
      res = res .. '[+]'
    end

    local ro = a.nvim_buf_get_option(buf, 'readonly')
    if ro then
      res = res .. '[RO]'
    end

    -- hide if the 1st line in buffer is too long
    --local cursor_buf_pos = a.nvim_win_get_cursor(buf)[1]
    --local cursor_win_pos = fn.screenrow()
    --if o.winbar:get() ~= '' then -- winbar counts as a window row
    --  cursor_win_pos = cursor_win_pos - 1
    --end
    --if cursor_buf_pos == cursor_win_pos then
    --  local first_line = a.nvim_buf_get_lines(buf, 0, 1, false)[1]
    --  local incline_opts = 5 -- margin + padding + 2 column for a good look
    --  local num
    --  local sign
    --  --local fold -- I'm too lazy to calculate this

    --  if o.number:get() or o.relativenumber:get() then
    --    num = o.numberwidth:get()
    --  else
    --    num = 0
    --  end

    --  if o.signcolumn:get() then
    --    -- I'm too lazy to calculate this
    --    sign = 2
    --  else
    --    sign = 0
    --  end

    --  local length = ( #res + #first_line + incline_opts + num + sign )
    --  if length > a.nvim_win_get_width(win) then
    --    return
    --  end
    --end

    local first_line = a.nvim_buf_get_lines(buf, 0, 1, false)[1]
    local incline_opts = 5 -- margin + padding + 2 column for a good look
    local num
    local sign
    --local fold -- I'm too lazy to calculate this

    if o.number:get() or o.relativenumber:get() then
      num = o.numberwidth:get()
    else
      num = 0
    end

    if o.signcolumn:get() then
      -- I'm too lazy to calculate this
      sign = 2
    else
      sign = 0
    end

    local length = ( #res + #first_line + incline_opts + num + sign )
    if length > a.nvim_win_get_width(win) then
      return
    end

    return res
  end,
}
