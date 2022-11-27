Load 'incline'.setup {
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
    local res
    local buf = props.buf
    local win = props.win
    local name = vim.api.nvim_buf_get_name(buf)

    if vim.api.nvim_buf_get_option(buf, 'buftype') == 'help' then
      return vim.fs.basename(name)
    elseif not vim.api.nvim_buf_get_option(buf, 'buflisted') then
      return
    elseif vim.api.nvim_buf_get_option(buf, 'buftype') == 'nofile' and
        name:match('man://') then
      return vim.fs.basename(name:gsub('man://', ''))
    elseif vim.api.nvim_buf_get_option(buf, 'buftype') == 'nofile' then
      return
    elseif name ~= '' then
      res = vim.fn.fnamemodify(name, ':~:.')
    else
      res = '[No Name]'
    end

    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if ft ~= '' then
      res = '[' .. ft .. ']' .. res
    end

    if vim.api.nvim_buf_get_option(buf, 'modified') then
      res = res .. '[+]'
    end

    local ro = vim.api.nvim_buf_get_option(buf, 'readonly')
    if ro then
      res = res .. '[RO]'
    end

    -- hide if the 1st line in buffer is too long and we see it
    local function is_too_long()
      local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
      local incline_opts = 5 -- margin + padding + 2 column for a good look
      local num = 0
      local sign
      local fold = tonumber(vim.opt_local.foldcolumn:get()) or 0

      if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
        num = vim.opt_local.numberwidth:get()
      end

      local s = vim.opt_local.signcolumn:get()
      if s == 'number' and num ~= 0 then
        sign = 0
      elseif s == 'auto' or s == 'yes' or s == 'number' then
        sign = 2
      else
        sign = s:sub(#s)
      end

      local length = (#res + #first_line + incline_opts + num + sign + fold)
      return vim.api.nvim_win_get_width(win) < length
    end

    if vim.fn.line('w0') == 1 and is_too_long() then
      return
    end

    return res
  end,
}
