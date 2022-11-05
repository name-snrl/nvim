local t = Load 'telescope'
local act = Load 'telescope.actions'

t.setup {
  defaults = {
    scroll_strategy = 'limit',
    layout_strategy = 'bottom_pane',
    layout_config = {
      bottom_pane = {
        height = 15,
        prompt_position = 'bottom'
      },
    },
    border = false,
    path_display = { truncate = 5 },
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    dynamic_preview_title = true,
    mappings = {
      i = {
        ['<C-x>'] = act.delete_buffer,
        ['<C-s>'] = act.select_horizontal,
      },

      n = {
        ['<C-x>'] = act.delete_buffer,
        ['<C-s>'] = act.select_horizontal,
      },
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',

      '--follow',
      '--hidden',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    }
  }
}

t.load_extension('fzf', 'zoxide')
Load 'telescope._extensions.zoxide.config'.setup {
  mappings = {
    default = {
      action = function(selection)
        vim.cmd("lcd " .. selection.path)
      end,
      after_action = function(selection)
        print("Directory changed to " .. selection.path)
        vim.fn.system('zoxide add ' .. selection.path)
      end
    }
  }
}

-- TODO
-- 1. Create builtin undotree. e.g. simnalamburt/vim-mundo mbbill/undotree
-- 2. The ability to see unlisted help and man buffers in builin.buffers.
