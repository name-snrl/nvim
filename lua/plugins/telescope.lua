local t = Load 'telescope'
local act = Load 'telescope.actions'

t.setup {
  defaults = {
    scroll_strategy = 'limit',
    layout_strategy = 'bottom_pane',
    layout_config = {
      bottom_pane = {
        height = 15,
        prompt_position = 'bottom',
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
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    undo = {
      diff_context_lines = 5,
      layout_config = {
        height = 25,
        preview_cutoff = 80,
        preview_width = 0.7,
      },
      mappings = {
        i = {
          ['<CR>'] = Load('telescope-undo.actions').restore,
          ['<C-c>'] = Load('telescope-undo.actions').yank_additions,
          ['<C-x>'] = Load('telescope-undo.actions').yank_deletions,
        },
      },
    },
  },
}

t.load_extension 'fzf'
t.load_extension 'zoxide'
t.load_extension 'undo'
Load('telescope._extensions.zoxide.config').setup {
  mappings = {
    default = {
      action = function(selection)
        vim.cmd('lcd ' .. selection.path)
      end,
      after_action = function(selection)
        print('Directory changed to ' .. selection.path)
        vim.fn.system('zoxide add ' .. selection.path)
      end,
    },
  },
}

-- TODO: The ability to see unlisted help and man buffers in builin.buffers.
