local branches_per_buf = {}
local git_dir_per_file_dir = {}
local watch_head = vim.uv.new_fs_event()

_G.get_branch = function()
  local cache = branches_per_buf[vim.api.nvim_get_current_buf()]
  if cache then
    return cache
  end
  return ' '
end

local function fmt(branch)
  branch = ' ' .. branch
  if branch:len() >= 16 then
    branch = branch:sub(1, 16) .. '…'
  end
  return branch
end

local function resolve_branch(bufnr, git_dir)
  watch_head:stop()
  local head_file = git_dir .. '/HEAD'

  local f = io.open(head_file)
  if f then
    local head = f:read()
    f:close()
    local branch = head:match 'ref: refs/heads/(.+)$'
    if branch then
      branches_per_buf[bufnr] = fmt(branch)
    else -- hash
      branches_per_buf[bufnr] = fmt(head:sub(1, 7))
    end
  end

  watch_head:start(
    head_file,
    {},
    vim.schedule_wrap(function()
      resolve_branch(bufnr, git_dir)
      vim.cmd 'redraw!'
    end)
  )
end

local function define_git_branch(bufnr)
  local file_dir
  local git_dir

  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  if buf_name == '' then
    file_dir = vim.uv.cwd()
  else
    file_dir = vim.fs.dirname(buf_name)
  end

  local root_dir = file_dir
  while root_dir do
    if git_dir_per_file_dir[root_dir] then
      git_dir = git_dir_per_file_dir[root_dir]
      break
    end

    local try_git_path = root_dir .. '/.git'
    local git_file_stat = vim.uv.fs_stat(try_git_path)

    if git_file_stat then
      if git_file_stat.type == 'directory' then
        git_dir = try_git_path
      elseif git_file_stat.type == 'file' then
        -- separate git-dir or submodule is used
        local file = io.open(try_git_path)
        if file then
          git_dir = file:read()
          git_dir = git_dir and git_dir:match 'gitdir: (.+)$'
          file:close()
        end
        -- submodule / relative file path
        if git_dir and git_dir:sub(1, 1) ~= '/' and not git_dir:match '^%a:.*$' then
          git_dir = try_git_path:match '(.*).git' .. git_dir
        end
      end
      if git_dir then
        local head_file_stat = vim.uv.fs_stat(git_dir .. '/HEAD')
        if head_file_stat and head_file_stat.type == 'file' then
          break
        else
          git_dir = nil
        end
      end
    end

    root_dir = root_dir:match '(.*)/.-'
  end

  if git_dir then
    git_dir_per_file_dir[file_dir] = git_dir
    resolve_branch(bufnr, git_dir)
  end
end

Load('core.utils').create_autocmds {
  BufEnter = {
    group = 'core.ruler',
    callback = function(ev)
      if vim.api.nvim_buf_get_option(ev.buf, 'buftype') == '' then
        define_git_branch(ev.buf)
      end
    end,
  },
}
