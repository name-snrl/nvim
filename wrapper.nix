{
  lib,
  writeText,
  neovimUtils,
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
}:

let
  binPath = lib.makeBinPath ([ git ] ++ extraBinPath);

  preInit =
    # lua
    ''
      -- Globals
      vim.g.is_nix_package = 1
    ''
    +
      lib.optionalString (repo != null) # lua
        ''
          -- Bootstrap cfg
          local repo = '${repo}'
          local cfg_path = vim.fn.stdpath 'config'

          if vim.loop.fs_stat(cfg_path) then
            if
              vim.fn
                .system({
                  'env',
                  '-S',
                  '-i',
                  'HOME="$HOME"',
                  '${git}/bin/git',
                  '-C',
                  vim.fn.stdpath 'config',
                  'remote',
                  'get-url',
                  'origin',
                })
                :find(repo, 1, true)
            then
              return
            end
            vim.loop.fs_rename(cfg_path, cfg_path .. '_backup_' .. os.date '%H%M%S_%d-%m-%Y')
          end

          vim.fn.system({ '${git}/bin/git', 'clone', repo, cfg_path })
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
in
wrapNeovimUnstable neovim-unwrapped config
