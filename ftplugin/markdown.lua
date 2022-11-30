local function create_md_file(name)
  if not name then name = vim.fn.expand '<cfile>' end
  if not name:match('.md$') then
    print 'Add an extension to the word and try again'
    return
  end
  io.open(name, 'a'):close()
end

local function input(opts)
  -- toggle to the english layout
  local kb_layout = vim.opt_local.iminsert:get()
  if kb_layout ~= 0 then
    vim.opt_local.iminsert = 0
  end

  local res
  vim.ui.input(
    opts,
    function(n)
      vim.opt_local.iminsert = kb_layout -- back to the initial layout
      res = n
    end
  )
  return res
end

local function cursor_line()
  local row, column = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
  return line, row, column
end

local function buf_content()
  return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

local function toggle_layout()
  if vim.opt_local.iminsert:get() == 1 then
    vim.opt_local.iminsert = 0
  else
    vim.opt_local.iminsert = 1
  end
end

local function toggle_checkbox()
  local line, row = cursor_line()

  if line:match('%[ %]') then
    local new_line = line:gsub('%[ %]', '[X]')
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
  elseif line:match('%[X%]') then
    local new_line = line:gsub('%[X%]', '[ ]')
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
  end
end

local function dec_heading()
  local line, row = cursor_line()

  if not line:match('^#') then
    vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { '# ' })
  else
    vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { '#' })
  end
end

local function inc_heading()
  local line, row = cursor_line()

  if line:match('^##') then
    vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 1, { '' })
  end
end

local function create_link()

  local link = input({
    prompt = 'Link to: ',
    default = '',
    completion = 'file'
  })

  if not link then
    vim.cmd 'mode' -- clear the cmd-line
    return
  elseif not link:match('://') then
    if not link:match('.md$') then
      link = link .. '.md'
    end
    create_md_file(link)
  end

  if vim.api.nvim_get_mode().mode == 'v' then
    vim.cmd('exe "normal! c[\\<C-r>\\"](' .. link .. ')"')
  else
    vim.cmd('exe "normal! hciw[\\<C-r>\\"](' .. link .. ')"')
  end
end

-- Rename the <cfile> and all references to it in
-- the files of the current directory. Only .md files.
local function rename()

  local function get_new_name()
    local name = input({
      prompt = 'New file name: ',
      default = '',
      completion = 'file'
    })

    if not name then
      vim.cmd 'mode' -- clear the cmd-line
      return
    elseif not tostring(name):match('.md$') then
      name = name .. '.md'
    end

    return name
  end

  local function get_old_name()
    local name = vim.fn.expand '<cfile>'

    if not name:match('.md$') then
      print 'The word under the cursor has no md extension'
      return
    elseif not vim.fs.find(name)[1] then
      print 'No such file'
      return
    elseif name == vim.fs.basename(vim.api.nvim_buf_get_name(0)) then
      print "You cannot rename the current file"
      return
    end

    return name
  end

  local function substitute(old, new, file_tbl)
    -- remove the current file name from the table
    local cur_file_name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
    for i in pairs(file_tbl) do
      if file_tbl[i] == cur_file_name then
        table.remove(file_tbl, i)
        break
      end
    end

    -- substitute in the current buffer
    for k, v in pairs(buf_content()) do
      local new_line = v:gsub(old, new)
      vim.api.nvim_buf_set_lines(0, k - 1, k, false, { new_line })
    end

    -- substitute in the files of the current directory
    for _, v in pairs(file_tbl) do

      local content

      -- read data
      local r, r_err = io.open(v, "r")
      if r then
        content = r:read("*all")
        r:close()
      else
        print(r_err)
        goto continue
      end

      -- make changes
      if content then
        content = content:gsub(old, new)
      else
        goto continue
      end

      -- write data
      local w, w_err = io.open(v, 'w')
      if w then
        w:write(content)
        w:close()
      else
        print(w_err)
        goto continue
      end
      ::continue::
    end

    return true
  end

  local old_name = get_old_name()
  if not old_name then return end
  local new_name = get_new_name()
  if not new_name then return end
  local file_list = {}
  for f in vim.fs.dir('.') do
    if f:match('.md$') then
      table.insert(file_list, f)
    end
  end

  if substitute(old_name, new_name, file_list) and
      os.rename(old_name, new_name) then
    print 'Successful'
  else
    print 'Unexpected error'
  end
end

-- Setup
Load 'core.utils'.set_opts_local {
  conceallevel = 2,
  textwidth = 80,
  undolevels = 10000,
  keymap = 'russian-markdown',
}

Load 'core.utils'.set_maps {

  ['!'] = {
    { '<C-_>', '<C-^>' },
  },
  ['i'] = {

    { '<C-l>', create_link },
    { '<C-j>', '<Cmd>undo<CR>' },
    { '<C-k>', '<Cmd>redo<CR>' },

    -- auto new undoable edit
    { '<Space>', '<C-g>u<Space>' },
    { '<C-m>', '<C-g>u<C-m>' },
    { '<C-w>', '<C-g>u<C-w>' },
    { '<C-u>', '<C-g>u<C-u>' },
  },
  [{ 'n', 'x' }] = {

    { '+', inc_heading },
    { '-', dec_heading },
    { '<CR>', toggle_checkbox },
    { 'cv', rename },
    { '<Leader>l', create_link },
    { '<Leader><C-_>', toggle_layout },
  },
}

Load 'core.utils'.create_autocmds {
  -- scrolloff for insert-mode
  CursorMovedI = {
    group = 'ftplugin.markdown',
    callback = function()
      if vim.opt_local.buftype:get() == '' then
        local h = vim.api.nvim_win_get_height(0) - vim.opt_local.scrolloff:get()
        local pos = vim.fn.winline()
        if pos > h then
          local offset = pos - h
          local winpos = vim.fn.winsaveview()
          winpos.topline = winpos.topline + offset
          vim.fn.winrestview(winpos)
        end
      end
    end,
  },
}

Load 'core.utils'.set_hls {
  DiagnosticVirtualTextHint = { link = 'Comment' }
}
