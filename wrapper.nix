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

  binPath = lib.makeBinPath (extraBinPath ++ [ git ]
    ++ lib.optionals withLua luaBins
    ++ lib.optionals withNix nixBins
    ++ lib.optionals withBash bashBins
    ++ lib.optionals withScala scalaBins
    ++ lib.optionals withMarkdown markdownBins);

  parsers = symlinkJoin {
    name = "nvim-treesitter-parsers";
    paths = with vimPlugins.nvim-treesitter-parsers;
      (extraTSParsers
        ++ lib.optional withNix nix
        ++ lib.optional withScala scala
        ++ lib.optional withMarkdown markdown_inline);
  };

  toNum = bool: if bool == true then "1" else "0";

  globals = lib.concatStringsSep ";"
    (lib.singleton "vim.g.is_nix_package=1"
      ++ lib.optional withLua "vim.g.lua_support=${toNum withLua}"
      ++ lib.optional withNix "vim.g.nix_support=${toNum withNix}"
      ++ lib.optional withBash "vim.g.bash_support=${toNum withBash}"
      ++ lib.optional withScala "vim.g.scala_support=${toNum withScala}"
      ++ lib.optional withMarkdown "vim.g.markdown_support=${toNum withMarkdown}");

  bootstrap = writeText "bootstrap.lua" ''
    local repo = '${repo}'
    local cfg_path = vim.fn.stdpath 'config'

    if vim.loop.fs_stat(cfg_path) then
      if
        vim
          .system({ 'git', '-C', cfg_path, 'remote', 'get-url', 'origin' })
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
      wrapperArgs = cfg.wrapperArgs ++ [ "--add-flags" ''--cmd "lua ${globals}"'' ]
      ++ lib.optionals (binPath != "") [ "--suffix" "PATH" ":" binPath ]
      ++ lib.optionals (parsers != "") [ "--add-flags" ''--cmd "set rtp^=${parsers}"'' ]
      ++ lib.optionals (repo != null) [ "--add-flags" ''--cmd "luafile ${bootstrap}"'' ];
    };
in
wrapNeovimUnstable neovim-unwrapped config
