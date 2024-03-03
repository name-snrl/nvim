{
  lib,
  writeText,
  symlinkJoin,
  neovimUtils,
  vimPlugins,
  wrapNeovimUnstable,
  neovim-unwrapped,
  git,
  extraName ? "",
  vimAlias ? false,
  viAlias ? false,
  withPython3 ? false,
  extraPython3Packages ? (_: [ ]),
  extraLuaPackages ? (_: [ ]),
  withNodeJs ? false,
  withPerl ? false,
  withRuby ? false,
  repo ? null,
  additionalPreInit ? "",
  additionalWrapperArgs ? [ ],
  extraBinPath ? [ ],
  extraTSParsers ? [ ],
  rebuildWithTSParsers ? false,
}:

let
  binPath = lib.makeBinPath ([ git ] ++ extraBinPath);

  bundled-parsers = with vimPlugins.nvim-treesitter-parsers; [
    c
    lua
    vim
    vimdoc
    query
    python
    bash
    markdown
    markdown_inline
  ];

  parsers = symlinkJoin {
    name = "nvim-ts-parsers";
    paths = bundled-parsers ++ extraTSParsers;
  };

  preInit =
    ''
      -- Globals
      vim.g.is_nix_package = 1
    ''
    + lib.optionalString (!rebuildWithTSParsers) ''
      -- Add TS parsers to 'runtimepath'
      vim.opt.runtimepath:prepend '${parsers}'
      -- lazy.nvim resets 'rtp', so we need global to set 'rtp' inside cfg
      vim.g.nix_ts_parsers = '${parsers}'
    ''
    + lib.optionalString (repo != null) ''
      -- Bootstrap cfg
      local repo = '${repo}'
      local cfg_path = vim.fn.stdpath 'config'

      if vim.loop.fs_stat(cfg_path) then
        if
          vim.fn
            .system({
              'env',
              '-i',
              'HOME="$HOME"',
              'bash',
              '-l',
              '-c',
              'git -C ' .. vim.fn.stdpath 'config' .. ' remote get-url origin',
            })
            :find(repo, 1, true)
        then
          return
        end
        vim.loop.fs_rename(cfg_path, cfg_path .. '_backup_' .. os.date '%H%M%S_%d-%m-%Y')
      end

      vim.fn.system({ 'git', 'clone', repo, cfg_path })
    ''
    + additionalPreInit;

  config =
    let
      cfg = neovimUtils.makeNeovimConfig {
        inherit extraName;
        inherit vimAlias;
        inherit viAlias;
        inherit withPython3;
        inherit extraPython3Packages;
        inherit extraLuaPackages;
        inherit withNodeJs;
        inherit withPerl;
        inherit withRuby;
        wrapRc = false;
      };
    in
    cfg
    // {
      wrapperArgs =
        cfg.wrapperArgs
        ++ [
          "--suffix"
          "PATH"
          ":"
          binPath
        ]
        ++ [
          "--add-flags"
          ''--cmd "luafile ${writeText "pre-init.lua" preInit}"''
        ]
        ++ additionalWrapperArgs;
    };

  neovim-package =
    if rebuildWithTSParsers then
      (neovim-unwrapped.override { treesitter-parsers = { }; }).overrideAttrs (
        oa: {
          preConfigure =
            oa.preConfigure
            + ''
              cp -f ${parsers}/parser/* $out/lib/nvim/parser/
            '';
        }
      )
    else
      neovim-unwrapped;
in
wrapNeovimUnstable neovim-package config
