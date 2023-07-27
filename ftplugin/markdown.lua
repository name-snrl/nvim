local function toggle_preview()
  local ok, peek = pcall(require, 'peek')
  if not ok then
    return
  end
  if peek.is_open() then
    peek.close()
  else
    peek.open()
  end
end

Load('core.utils').set_maps {
  ['i'] = {
    { '<C-j>', '<Cmd>undo<CR>' },
    { '<C-k>', '<Cmd>redo<CR>' },
    -- auto new undoable edit
    { '<Space>', '<C-g>u<Space>' },
    { '<C-m>', '<C-g>u<C-m>' },
    { '<C-w>', '<C-g>u<C-w>' },
    { '<C-u>', '<C-g>u<C-u>' },
  },
  [{ 'n', 'x' }] = {
    { '<Leader>p', toggle_preview },
  },
}

Load('core.utils').set_opts_local {
  conceallevel = 2,
  textwidth = 80,
  undolevels = 10000,
}

Load('core.utils').create_autocmds {
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

Load('core.utils').set_hls {
  DiagnosticVirtualTextError = { link = 'Comment' },
}
