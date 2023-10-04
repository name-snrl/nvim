Load('mkdnflow').setup {
  modules = {
    bib = false,
    buffers = false,
    conceal = false,
    cursor = true,
    folds = true,
    links = true,
    lists = true,
    maps = true,
    paths = true,
    tables = true,
    yaml = false,
  },
  perspective = {
    priority = 'root',
    fallback = 'first',
    root_tell = '.git',
    nvim_wd_heel = true,
    update = true,
  },
  links = {
    style = 'markdown',
    implicit_extension = nil,
    transform_explicit = function()
      local link
      vim.ui.input({
        prompt = 'Link to: ',
        default = '',
        completion = 'file',
      }, function(input)
        link = input
      end)

      if not link then
        vim.cmd.mode() -- clear the cmd-line
        return
      elseif not link:match '://' then
        link = '/' .. link
        if not link:match '.md$' then
          link = link .. '.md'
        end
      end

      return link
    end,
    transform_implicit = function(link)
      if not link:match '://' then
        link = link:sub(2)
      end
      return link
    end,
  },
  paths = { update_link_everywhere = true },
  new_file_template = { use_template = false },
  to_do = {
    symbols = { ' ', 'x', ' ' },
    update_parents = false,
  },
  tables = {
    trim_whitespace = true,
    format_on_move = true,
    auto_extend_rows = true,
    auto_extend_cols = true,
  },
  mappings = {
    MkdnEnter = false,
    MkdnTab = false, -- standard <C-t> does the same
    MkdnSTab = false, -- standard <C-d> does the same
    MkdnNextLink = false,
    MkdnPrevLink = false,
    MkdnNextHeading = false, -- standard ftplugin contains this
    MkdnPrevHeading = false, -- standard ftplugin contains this
    MkdnGoBack = false,
    MkdnGoForward = false,
    MkdnCreateLink = { 'n', 'yu' },
    MkdnCreateLinkFromClipboard = false,
    MkdnFollowLink = { 'n', 'gd' },
    MkdnDestroyLink = { 'n', 'du' },
    MkdnTagSpan = false,
    MkdnMoveSource = { 'n', 'cv' },
    MkdnYankAnchorLink = false,
    MkdnYankFileAnchorLink = false,
    MkdnIncreaseHeading = { 'n', '+' },
    MkdnDecreaseHeading = { 'n', '-' },
    MkdnToggleToDo = { { 'n', 'x' }, '<CR>' },
    MkdnNewListItem = { 'i', '<CR>' },
    MkdnNewListItemBelowInsert = { 'n', 'o' },
    MkdnNewListItemAboveInsert = { 'n', 'O' },
    MkdnExtendList = false,
    MkdnUpdateNumbering = { 'n', '=' },
    MkdnTableNextCell = { 'i', '<C-l>' },
    MkdnTablePrevCell = { 'i', '<C-h>' },
    MkdnTableNextRow = false,
    MkdnTablePrevRow = false,
    MkdnTableNewRowBelow = { 'n', 'yrb' },
    MkdnTableNewRowAbove = { 'n', 'yra' },
    MkdnTableNewColAfter = { 'n', 'yca' },
    MkdnTableNewColBefore = { 'n', 'ycb' },
    MkdnFoldSection = false,
    MkdnUnfoldSection = false,
  },
}
