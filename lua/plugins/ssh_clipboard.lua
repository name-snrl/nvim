vim.fn.timer_start(1000, function()
  if vim.g.loaded_clipboard_provider ~= 2 then
    local function copy(lines, _)
      require('osc52').copy(table.concat(lines, '\n'))
    end

    local function paste()
      return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
    end

    vim.g.clipboard = {
      name = 'osc52',
      copy = { ['+'] = copy, ['*'] = copy },
      paste = { ['+'] = paste, ['*'] = paste },
    }
    vim.g.loaded_clipboard_provider = nil
    vim.cmd 'runtime autoload/provider/clipboard.vim'
  end
end)
