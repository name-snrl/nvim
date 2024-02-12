{ lib
, writeText
, symlinkJoin
, neovimUtils
, vimPlugins
, wrapNeovimUnstable
, neovim-unwrapped
, git
  # lua
, sumneko-lua-language-server
, stylua
  # nix
, nil
, nixpkgs-fmt
  # bash
, nodePackages
, shfmt
, shellcheck
  # scala
, metals
, scalafmt
  # markdown
, languagetool-rust
, deno

  # Arguments to be inherited in pkgs.neovimUtils.makeNeovimConfig
  # which will then passed to pkgs.wrapNeovimUnstable
, extraName ? ""
, vimAlias ? false
, viAlias ? false
, withPython3 ? false # just inherited
, extraPython3Packages ? (_: [ ])
, extraLuaPackages ? (_: [ ])
, withNodeJs ? false
, withPerl ? false
, withRuby ? false

  # Language support
  # 
  # If true, then:
  # - adds language tools to $PATH.
  # - adds treesitter parser.
  # - sets global-variable (g:<lang>_support).
, withLua ? false
, withNix ? false
, withBash ? false
, withScala ? false
, withMarkdown ? false

  # At startup, Nvim checks if this repo is a user config,
  # and load it if it is not
, repo ? null
, extraBinPath ? [ ]
, extraTSParsers ? [ ]
}:

let
  luaBins = [
    sumneko-lua-language-server
    stylua
  ];
  nixBins = [
    nil
    nixpkgs-fmt
  ];
  bashBins = [
    nodePackages.bash-language-server
    shfmt
    shellcheck
  ];
  scalaBins = [
    metals
    scalafmt
  ];
  markdownBins = [
    languagetool-rust
    deno
  ];

  binPath = lib.makeBinPath (
    [ git ]
    ++ lib.optionals withLua luaBins
    ++ lib.optionals withNix nixBins
    ++ lib.optionals withBash bashBins
    ++ lib.optionals withScala scalaBins
    ++ lib.optionals withMarkdown markdownBins
    ++ extraBinPath
  );

  parsers = with vimPlugins.nvim-treesitter-parsers;
    [ c lua vim vimdoc query python bash markdown markdown_inline ]
    ++ lib.optionals withLua [ luap luadoc ]
    ++ lib.optional withNix nix
    ++ lib.optional withScala scala
    ++ extraTSParsers
  ;

  preInit = ''
    -- Globals
    vim.g.is_nix_package = 1
  '' + lib.optionalString withLua ''
    vim.g.lua_support = 1
  '' + lib.optionalString withNix ''
    vim.g.nix_support = 1
  '' + lib.optionalString withBash ''
    vim.g.bash_support = 1
  '' + lib.optionalString withScala ''
    vim.g.scala_support = 1
  '' + lib.optionalString withMarkdown ''
    vim.g.markdown_support = 1
  '' + lib.optionalString (parsers != [ ]) (
    let path = symlinkJoin { name = "nvim-ts-parsers"; paths = parsers; }; in ''
      -- Add TS parsers to 'runtimepath'
      vim.opt.runtimepath:prepend '${path}'
      -- lazy.nvim resets 'rtp', so we need global to set 'rtp' inside cfg
      vim.g.nix_ts_parsers = '${path}'
    ''
  ) + lib.optionalString (repo != null) ''
    -- Bootstrap cfg
    local repo = '${repo}'
    local cfg_path = vim.fn.stdpath 'config'

    if vim.loop.fs_stat(cfg_path) then
      if
        vim
          .system({
            'env',
            '-i',
            'HOME="$HOME"',
            'bash',
            '-l',
            '-c',
            'git -C ' .. vim.fn.stdpath 'config' .. ' remote get-url origin',
          })
          :wait().stdout
          :find(repo, 1, true)
      then
        return
      end
      vim.loop.fs_rename(cfg_path, cfg_path .. '_backup_' .. os.date '%H%M%S_%d-%m-%Y')
    end

    vim.system({ 'git', 'clone', repo, cfg_path }):wait()
  '';

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
    cfg // {
      wrapperArgs = cfg.wrapperArgs
      ++ [ "--suffix" "PATH" ":" binPath ]
      ++ [ "--add-flags" ''--cmd "luafile ${writeText "pre_init.lua" preInit}"'' ];
    };
  nvim = neovim-unwrapped.override { treesitter-parsers = { }; };
in
wrapNeovimUnstable nvim config
