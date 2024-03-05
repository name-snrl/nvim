-- selene: allow(mixed_table)
return {
  'tpope/vim-fugitive',
  lazy = false,
  config = function()
    -- selene: allow(global_usage)
    _G.git_head = function()
      local head = vim.fn.FugitiveHead(7)
      if head == '' then
        return ' '
      elseif head:len() >= 14 then
        return ' ' .. head:sub(1, 14) .. '…'
      else
        return ' ' .. head
      end
    end
    vim.opt.rulerformat = '%35(%-17{v:lua.git_head()} %-13(%l,%c%V%) %P%)'
    vim.opt.laststatus = 0
  end,
  keys = {
    { 'go', '<Cmd>G | on<CR>' },
    { 'gl', '<Cmd>vert G log --oneline<CR>' },
    { 'g/', '<Cmd>vert G log --oneline %<CR>' },
    { 'gM', '<Cmd>G mergetool<CR>' },
    { 'gm', '<Cmd>Gvdiffsplit!<CR>' },
  },
}
