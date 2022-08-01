local cmd = vim.cmd
local fs = vim.fs
local ui = vim.ui
local fn = vim.fn
local o = vim.opt
local a = vim.api
local g = vim.g

local function create_md_file (name)
  if not name then name = fn.expand'<cfile>' end
  if not name:match('.md$') then
    print'Add an extension to the word and try again'
    return
  end
  io.open(name, 'a'):close()
end

local function input (opts)
  -- toggle to the english layout
  local kb_layout = o.iminsert:get()
  if kb_layout ~= 0 then
    o.iminsert = 0
  end

  local res
  ui.input(
    opts,
    function(n)
      o.iminsert = kb_layout -- back to the initial layout
      res = n
    end
  )
  return res
end

local function cursor_line ()
  local row, column = unpack(a.nvim_win_get_cursor(0))
  local line = a.nvim_buf_get_lines(0, row - 1, row, false)[1]
  return line, row, column
end

local function buf_content ()
  return a.nvim_buf_get_lines(0, 0, -1, false)
end

local function toggle_layout ()
  if o.iminsert:get() == 1 then
    o.iminsert = 0
  else
    o.iminsert = 1
  end
end

local function toggle_checkbox ()
  local line, row = cursor_line()

  if line:match('%[ %]') then
    local new_line = line:gsub('%[ %]', '[X]')
    a.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
  elseif line:match('%[X%]') then
    local new_line = line:gsub('%[X%]', '[ ]')
    a.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
  end
end

local function dec_heading ()
  local line, row = cursor_line()

  if not line:match('^#') then
    a.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, {'# '})
  else
    a.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, {'#'})
  end
end

local function inc_heading ()
  local line, row = cursor_line()

  if line:match('^##') then
    a.nvim_buf_set_text(0, row - 1, 0, row - 1, 1, {''})
  end
end

local function create_link ()

  local link = input({
    prompt = 'Link to: ',
    default = '',
    completion = 'file'
  })

  if not link then
    cmd'mode' -- clear the cmd-line
    return
  elseif not link:match('://') then
    if not link:match('.md$') then
      link = link .. '.md'
    end
    create_md_file(link)
  end

  if a.nvim_get_mode().mode == 'v' then
    cmd('exe "normal! c[\\<C-r>\\"](' .. link .. ')"')
  else
    cmd('exe "normal! ciw[\\<C-r>\\"](' .. link .. ')"')
  end
end

-- Rename the <cfile> and all references to it in
-- the files of the current directory. Only .md files.
local function rename ()

  local function get_new_name ()
    local name = input({
      prompt = 'New file name: ',
      default = '',
      completion = 'file'
    })

    if not name then
      cmd'mode' -- clear the cmd-line
      return
    elseif not tostring(name):match('.md$') then
      name = name .. '.md'
    end

    return name
  end

  local function get_old_name ()
    local name = fn.expand'<cfile>'

    if not name:match('.md$') then
      print'The word under the cursor has no md extension'
      return
    elseif not fs.find(name)[1] then
      print'No such file'
      return
    elseif name == fs.basename(a.nvim_buf_get_name(0)) then
      print"You cannot rename the current file"
      return
    end

    return name
  end

  local function substitute (old, new, file_tbl)
    -- remove the current file name from the table
    local cur_file_name = fs.basename(a.nvim_buf_get_name(0))
    for i in pairs(file_tbl) do
      if file_tbl[i] == cur_file_name then
        table.remove(file_tbl, i)
        break
      end
    end

    -- substitute in the current buffer
    for k, v in pairs(buf_content()) do
      local new_line = v:gsub(old, new)
      a.nvim_buf_set_lines(0, k - 1, k, false, { new_line })
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
  for f in fs.dir('.') do
    if f:match('.md$') then
      table.insert(file_list, f)
    end
  end

  if substitute(old_name, new_name, file_list) and
    os.rename(old_name, new_name) then
    print'Successful'
  else
    print'Unexpected error'
  end
end

-- Markdown preview
local run_preview
local close_preview
-- Requirements: pandoc and qutebrowser
do

  local tmp = '/tmp/nvim-md-preview.html' -- deleted with close_preview()
  local plugin_path = fn.expand('<sfile>:h')

  local style = plugin_path .. '/style.css'
  local gh = plugin_path .. '/github-markdown.css'
  local before = plugin_path .. '/before-body.html'
  local after = plugin_path .. '/after-body.html'

  -- get window position relative to the buffer(in percent)
  local function position ()

    local result
    local buf_row_count = a.nvim_buf_line_count(0)
    local win_row_count = a.nvim_win_get_height(0)
    local cursor_buf_pos = a.nvim_win_get_cursor(0)[1]
    local cursor_win_pos = fn.winline()
    local win_pos = a.nvim_win_get_position(0)[1]

    if o.winbar:get() ~= '' then -- winbar counts as a window row
      win_row_count = win_row_count - 1
    end

    if win_row_count >= buf_row_count then
      result = cursor_buf_pos * 100 / buf_row_count
    else

      if o.winbar:get() ~= '' then win_pos = win_pos + 1 end
      cursor_win_pos = cursor_win_pos - win_pos

      local offset = win_row_count / 2 - cursor_win_pos
      local screen_pos = cursor_buf_pos + offset
      -- let's represent the screen as a single line
      screen_pos = screen_pos - win_row_count / 2
      buf_row_count = buf_row_count - win_row_count

      result = screen_pos * 100 / buf_row_count
    end

    return tostring(math.floor(result))
  end

  local function start ()
    return string.format(
      'qutebrowser ":open %s;;later 1s scroll-to-perc %s"',
      tmp, position()
    )
  end

  local function reload ()
    return string.format(
      'qutebrowser ":reload;;later 0.5s scroll-to-perc %s"',
      position()
    )
  end

  local function pandoc ()
    return string.format(
      'pandoc -B %s -A %s --css=%s --css=%s ' ..
      '-f gfm+tex_math_dollars --mathjax --no-highlight %s -o %s',
      before,
      after,
      gh,
      style,
      tmp,
      tmp
    )
  end

  local function job_checker (job, name)
    if job == 0 then
      print(name .. ' filed: jobstart() return 0')
      return
    elseif job == -1 then
      print(name .. ' filed: jobstart() return -1')
      return
    end
  end

  -- run or refresh qutebrowser
  local function qutebrowser ()

    local function run (command)
      local job_id = fn.jobstart( command(),
        { on_exit = function() cmd'mode' end } -- clear cmd-line
      )
      job_checker(job_id, 'Qutebrowser')
      if not g.qutebrowser_job_id then
        g.qutebrowser_job_id = job_id
      end
    end

    if pcall(fn.jobpid, g.qutebrowser_job_id) then
      print'Updating...'
      run(reload)
    else
      print'Starting preview...'
      g.qutebrowser_job_id = nil

      if fn.system('pgrep qutebrowser') ~= '' then
        local job_id = fn.jobstart( 'qutebrowser ":quit"',
          { on_exit = function() run(start) end }
        )
        job_checker(job_id, 'pkill')
      else
        run(start)
      end
    end
  end

  local function buf_same (new)
    local old = g.preview_file_content
    if not old then return end
    if #old ~= #new then return end
    for k, v in pairs(new) do
      if v ~= old[k] then
        return
      end
    end
    return true
  end

  function run_preview ()
    -- close the preview when exit vim
    a.nvim_create_autocmd('ExitPre',{
      callback = close_preview
    })

    local buf = buf_content()

    if buf_same(buf) then qutebrowser()
    else
      -- write the current buffer to the file
      local w, w_err = io.open(tmp, 'w')
      if w then
        for _, i in pairs(buf) do
          w:write(i .. '\n')
        end
        w:close()
      else
        print(w_err)
        return
      end

      -- save the current buffer
      g.preview_file_content = buf

      -- file processing
      local job_id = fn.jobstart( pandoc(), { on_exit = qutebrowser } )
      job_checker(job_id, 'Pandoc')
    end
  end

  function close_preview ()
    if g.qutebrowser_job_id then
      local was_stop = fn.jobstop(g.qutebrowser_job_id)
      if was_stop == 0 then
        print'Invalid job id'
      end
    else
      print'The preview has not been started'
    end
    -- mark preview closed
    g.qutebrowser_job_id = nil
    g.preview_file_content = nil
    os.remove(tmp)
  end
end


-- Setup
Load'core.utils'.set_opts_local {
  conceallevel = 2,
  textwidth = 80,
  wrap = false,
  undolevels = 10000,
  keymap = 'russian-markdown',
}

Load'core.utils'.set_maps {

  ['!'] = {
    { '<C-_>', '<C-^>' },
  },
  ['i'] = {

    { '<C-l>', create_link },
    { '<C-j>', '<Esc>uA' },
    { '<C-k>', '<Esc><C-r>A' },

    -- auto new undoable edit
    { '<Space>', '<C-G>u<Space>' },
    { '<C-m>',   '<C-G>u<C-m>' },
    { '<C-w>',   '<C-G>u<C-w>' },
    { '<C-u>',   '<C-G>u<C-u>' },
  },
  [{'n', 'x'}] = {

    { '+',             inc_heading },
    { '-',             dec_heading },
    { '<CR>',          toggle_checkbox },
    { 'cv',            rename },
    { '<Leader>l',     create_link },
    { '<Leader><C-_>', toggle_layout },
    { '<Leader>o',     run_preview },
    { '<Leader>q',     close_preview },
  },
}

Load'core.utils'.create_autocmds {
  -- scrolloff for insert-mode
  CursorMovedI = {
    group = 'ftplugin.markdown',
    callback = function()
      if o.buftype:get() == '' then
        local h = a.nvim_win_get_height(0) - o.scrolloff:get()
        local pos = fn.winline()
        if pos > h then
          local offset = pos - h
          cmd('exe "norm ' .. offset .. '\\<C-e>"')
        end
      end
    end,
  },
}

Load'core.utils'.set_hls {
  DiagnosticVirtualTextHint = { link = 'Comment' }
}

-- plugins
Load'indent_blankline.commands'.disable()
