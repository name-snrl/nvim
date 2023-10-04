local M = {}

function M.next_buf_arg()
  if not pcall(vim.cmd.next) then
    vim.cmd.bnext()
  end
end

function M.prev_buf_arg()
  if not pcall(vim.cmd.previous) then
    vim.cmd.bprev()
  end
end

function M.scroll_up()
  local cur = vim.o.scroll
  vim.o.scroll = vim.v.count1
  vim.cmd.exec '"norm! \\<C-u>"'
  vim.o.scroll = cur
end

function M.scroll_down()
  local cur = vim.o.scroll
  vim.o.scroll = vim.v.count1
  vim.cmd.exec '"norm! \\<C-d>"'
  vim.o.scroll = cur
end

return M
