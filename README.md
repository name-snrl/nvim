# Introduce

The KISS-based configuration that maximizes the use of Neovim's built-in
functionality.

# How my configuration might be useful to you?

## Fuck status lines. Current branch/commit in `:h 'ruler'`

I don't like all those overloaded status lines, so I just wrote this simple
branch/commit tracker for use in options like `:h 'rulerformat'`.

If you want the same copy [ruler.lua](/cfg_modules/core/ruler.lua) to your
config and configure the options according to your preferences at the bottom of
the file. By default it will look like a standard ruler, but with branch/commit
displayed, and will also disable the status bar.

Yes, now you can't see file names, you can use `:h 'winbar'` for that:

```lua
vim.opt.winbar = '%#Normal# %<%=%(%* %y%f%m%r%) '
```

I use it with a plugin like `SmiteshP/nvim-navic` to get the context on the left
side of the winbar and the file name on the right.

## [Nix](https://github.com/NixOS/nix) overlay/wrapper for configuring package content

Did he write another way to configure Neovim with nix?

No, I don't like all the things people are doing with Neovim using Nix. In my
opinion it just makes your user experience more complicated and uncomfortable.
Try to answer the following questions:

- What's the point of keeping your configuration in immutable store and losing
  the ability to make quick changes?
- We already have a first class supported language in Neovim to write our
  configuration with all that lsp stuff, syntax highlighting, etc. So why give
  it up?
- Any plugin, has instructions on how to install it easily by copying a snippet
  from the README. Is it really that much harder than enabling the option in
  Nix?
- Neovim already has a very cool
  [plugin manager](https://github.com/folke/lazy.nvim) with lazy loading, lock
  file and bytecode compilation. As far as I know the latter is not available in
  any Nix solution. So, what benefits will you get from Nix?

But I also want to have an easily portable Neovim configuration. So that on any
machine that has Nix installed, I can quickly get into my development
environment. That's why I wrote this. **My overlay allows you to define a Neovim
package with a number of dependencies, which also contains a small script to
bootstrap your Neovim configuration from git repo at startup.**

Unlike the solutions I know:

- The NixOS module in [nixpkgs](https://github.com/NixOS/nixpkgs)
- The module in [Home Manager](https://github.com/nix-community/home-manager)
- [nixvim](https://github.com/nix-community/nixvim)
- [neovim-flake](https://github.com/jordanisaacs/neovim-flake)

My overlay does not involve configuring Neovim with Nix. Instead, it enables you
to wrap the standard `neovim-unwrapped` package using the standard wrapper
provided in nixpkgs. This allows you to configure the following aspects:

- Add packages to `$PATH`, specifically for Neovim.
- Add Tree-sitter parsers via package rebuild or `:h 'rtp'` option.
- Add additional Lua code to `pre-init.lua`.
- Add additional arguments to
  [makeWrapper](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh).

Note. Here is a list of nvim-treesitter parsers that will be added anyway:

- c
- lua
- vim
- vimdoc
- query
- python
- bash
- markdown
- markdown_inline

The reason is that the bundled Neovim parsers may be out of date for
nvim-treesitter and cause errors.

https://github.com/nvim-treesitter/nvim-treesitter/issues/5873

`:h treesitter-parsers` to get list of the bundled parsers

### What is `pre-init.lua`?

This is a Lua file that is executed with the command
`--cmd "luafile pre-init.lua"`, which means that it is executed before any vimrc
is processed. It consists of:

- `vim.g.is_nix_package = 1`. This can be used to change the configuration based
  on whether Neovim is a package from this overlay.
- If `rebuildWithTSParsers` is false, which is the default behavior, it adds
  nvim-treesitter parsers to the 'runtimepath' option and sets the
  `nix_ts_parsers` global variable that stores the path to the parsers. This
  global variable can be used to redefine the 'runtimepath' option. So, for
  example, by default Lazy.nvim resets the 'runtimepath' option.
- If `repo` is not null, it also contains a snippet that checks and clones the
  repository from the specified URL. See the `repo` argument below.
- Any additional Lua code you specify with `additionalPreInit`.

### Arguments for override

Arguments that are simply passed to `neovimUtils.makeNeovimConfig`.
[Source](https://github.com/NixOS/nixpkgs/blob/7b9f4b6febde110cbe247ec71ec76da14b5c48ca/pkgs/applications/editors/neovim/utils.nix#L27-L123):

- `extraName`, **string**, default: `""`. The suffix to be added to the name
  attribute in the derivation.
- `viAlias`, **bool**, default: `false`. Similar to the
  `programs.neovim.viAlias` option in NixOS.
- `vimAlias`, **bool**, default: `false`. Similar to the
  `programs.neovim.vimAlias` option in NixOS.
- `withPython3`, **bool**, default: `false`. Similar to the
  `programs.neovim.withPython3` option in NixOS.
- `withNodeJs`, **bool**, default: `false`. Similar to the
  `programs.neovim.withNodeJs` option in NixOS.
- `withRuby`, **bool**, default: `false`. Similar to the
  `programs.neovim.withRuby` option in NixOS.
- `withPerl`, **bool**, default: `false`. Similar to the above options enable
  the Perl provider. But this is still an experimental option, be careful.
- `extraPython3Packages`, default: `_: [ ]`. A function that you normally pass
  in `python.withPackages`, but which is passed to the python provider Neovim.
- `extraLuaPackages`, default: `_: [ ]`. Similar to the above.

Additional arguments, that implemented inside `wrapper.nix`:

- `repo`, **string or null**, default: `null`. On startup, Nvim will check if
  the specified repository is a user configuration, and load it if it is not. If
  some configuration already exists but is not the specified repository, it will
  be renamed with the prefix "\_backup\_{current date}". The
  `git remote get-url origin` command is used for verification.
- `additionalPreInit`, **string**, default: `""`. Any Lua code you want to add
  to `pre-init.lua`. Be careful, it will be executed every time you open Neovim.
- `additionalWrapperArgs`, **list of string**, default: `[ ]`. As mentioned
  above, using this option you can add arguments to makeWrapper.
- `extraBinPath`, **list of package**, default: `[ ]`. Packages to be added to
  `$PATH`.
- `extraTSParsers`, **package list**, default: `[ ]`. Tree parsers to be added
  to 'rtp' and to the `nix_ts_parsers` global variable or to
  `$out/lib/nvim/parser/` if `rebuildWithTSParsers` is enabled.
- `rebuildWithTSParsers`, **bool**, default: `false`. Whether Tree-sitter
  parsers should be added via the 'runtimepath' option or by overriding the
  `preConfigure` phase in the `neovim-unwrapped` derivation. Rebuild is the more
  general and recommended approach, so if you are using the nightly version and
  already rebuild `neovim-unwrapped`, it is recommended to enable this option.

### Usage example

#### If you use flakes

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Add input
    nvim.url = "github:name-snrl/nvim";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
      # pass inputs to config
      specialArgs = { inherit inputs; };
    };
  };
}

# configuration.nix
{ pkgs, inputs, ... }: {
  nixpkgs.overlays = [
    # Add my overlay. It uses final.callPackage, so it doesn't matter the
    # sequence in which it is added, it will always use neovim-unwrapped from
    # the final package set.
    inputs.snrl-cfg.overlays.default
    # configure your own package
    (final: prev: {
      my-nvim = final.nvim.override {
        viAlias = true;
        vimAlias = true;
        repo = "https://github.com/<user-name>/<repo>";
        extraBinPath = with final; [
          curl
          fd
          ripgrep
        ];
        extraTSParsers = with final.vimPlugins.nvim-treesitter-parsers; [
          fish
          go
          rust
          css
          yaml
          dockerfile
        ];
      };
    })
  ];
  # add it to environment.systemPackages or wherever you want
  environment.systemPackages = with pkgs; [
    my-nvim
  ];
}
```

#### If you use channels

```nix
{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      my-nvim =
        let
          nvim-overlay = builtins.fetchTarball {
            url = "https://github.com/name-snrl/nvim/archive/from-scratch.tar.gz";
          };
        in
        final.callPackage "${nvim-overlay}/wrapper.nix" {
          # your overrides here
        };
    })
  ];
  # add it to environment.systemPackages or wherever you want
  environment.systemPackages = with pkgs; [
    my-nvim
  ];
}
```

### FAQ

#### What wrapping is?

This is creating a small bash script around the package to create its own
environment. As you may have noticed, nixpkgs has many packages with the suffix
`-unwrapped`, which means that it is a standardly built package with standard
output. But sometimes a wrapper is created for a package to work properly in
NixOS or to customize it through a module, so wrapped packages are hidden under
their normal names. What does a wrapper look like? Execute:

```bash
nvim "$(realpath "$(which nvim)")"
```

#### Is this causing Neovim to be rebuilt?

No, unless the `rebuildWithTSParsers` option is enabled. By default, this just
builds a thin bash wrapper around the `neovim-unwrapped` package.

#### How do I change the package that will be wrapped?

By default, the overlay uses your system's `neovim-unwrapped` package from the
`final` argument, which means that if you use
[neovim-nightly](https://github.com/nix-community/neovim-nightly-overlay), which
overrides the `neovim-unwrapped` package, you don't need to do anything. Or you
can specify the package manually via override:

```nix
final: prev: {
  my-nvim = final.nvim.override { neovim-unwrapped = prev.neovim-i-want-wrap; }
}
```

# Plugins I use

- git integration
  - [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

# TODO

- [ ] git integration
  - [ ] `tpope/vim-fugitive`
  - [ ] `lewis6991/gitsigns.nvim`
  - [ ] easy way to resolve merger conflicts
  - [ ] a tool to manage working trees, maybe `telescope` is all we need
  - [ ] easy way to clone a repo to /tmp followed by timeline-based exploration
  - [ ] `octo.nvim`/`tpope/vim-rhubarb`
  - [ ] branch/commit switching, `telescope`? yeah, `git_bcomits` looks so cool!
  - [ ] making fixups, `telescope`?
  - [ ] stash management, `telescope`?
  - [ ] working tree jumping, `telescope`?
- [ ] file navigation
  - [ ] `telescope`
    - [ ] git file same for grep
    - [ ] all files except .git/ same for grep
    - [ ] help files
    - [ ] man files
  - [ ] `harpoon`
- [ ] text navigation
  - [ ] `flash.nvim`
    - [ ] jump anywhere in the window
    - [ ] enhanced f/F/t/T
    - [ ] select ts-object
  - [ ] `vim-matchup`/`monkoose/matchparen.nvim`/`theHamsta/nvim-treesitter-pairs`,
    but do we realy need this?
  - [ ] project-wide replace with one of:
    - `nvimdev/lspsaga` rename
    - `nvim-pack/nvim-spectre`
- [ ] text processing
  - [ ] `kylechui/nvim-surround`
  - [ ] `numToStr/Comment.nvim`
- [ ] autopairs
  - `windwp/nvim-autopairs`
  - `nvimdev/dyninput.nvim`
  - `altermo/ultimate-autopair.nvim`
  - `echasnovski/mini.pairs`
  - or something else from
    <https://github.com/yutkat/my-neovim-pluginlist/blob/main/auto-insert.md#insert-pairs>
  - [ ] autopairs for lua tables and nix attrsets/lists/multi-strings, which
    will append a comma (lua) or semicolon (nix) to the pairing
  - [ ] pairs for markdown \`/\*\*/\_
  - [ ] a new line within a pair
  - [ ] default pairs
- [ ] `tree-sitter`
  - [x] highlighting using `vim.treesitter.start()`, looks like we don't need
    nvim-treesitter anymore. we still need `nvim-treesitter` because it contains
    queries for highlighting and everything else.
  - [ ] indent?
  - [ ] code navigation through `telescope`
- [ ] code context and breadcrumbs/outline can use `gO` mapping for oppening
  outline buffer, it makes same by default:
  - `SmiteshP/nvim-navic` and `SmiteshP/nvim-navbuddy` (only LSP). want the same
    but through treesitter
  - `nvimdev/lspsaga` outline
  - `stevearc/aerial.nvim`
  - `hedyhli/outline.nvim`
  - `Bekaboo/dropbar.nvim`
- [ ] `LSP`
  - [ ] `nvimdev/lspsaga`
  - [ ] `folke/trouble.nvim`
  - [ ] `j-hui/fidget.nvim`
  - [ ] `nvim-cmp` not sure we need this because Neovim now has an API
    `vim.snippet`.
- [ ] languages
  - [ ] lua
    - [ ] indentation
    - [ ] formatting
    - [ ] lsp, `neodev.nvim`, but we also use Neovim for writing mpv plugins
    - [ ] diagnostics
  - [ ] nix
    - [ ] indentation, Neovim does not provide good indentation rules for nix
      - <https://vi.stackexchange.com/questions/42674/how-to-fix-indentation-for-nix-files>
    - [ ] formatting
    - [ ] lsp
    - [ ] diagnostics
  - [ ] markdown
    - [ ] indentation
    - [ ] formatting
    - [ ] [lsp](https://github.com/microsoft/vscode-markdown-languageservice)
    - [ ] diagnostics
    - [ ] preview
  - [ ] bash
    - [ ] indentation
    - [ ] formatting
    - [ ] lsp
    - [ ] diagnostics
  - [ ] starlark
    - [ ] indentation
    - [ ] formatting
    - [ ] lsp
    - [ ] diagnostics
  - [ ] scala
    - [ ] indentation, Neovim does not provide good indentation rules for scala
    - [ ] formatting
    - [ ] lsp
    - [ ] diagnostics
  - [ ] starlark
    - [ ] indentation
    - [ ] formatting
    - [ ] lsp
      - [ ] hovers with bzl lsp
      - [ ] goto-definition with `alexander-born/bazel.nvim`
    - [ ] diagnostics
- [ ] appearance
  - [ ] `EdenEast/nightfox.nvim`
    - [ ] install
    - [ ] adjust lsp colors
      <https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens>
  - [ ] `lukas-reineke/indent-blankline.nvim`
  - [ ] add an image of the look
- [ ] misc
  - [ ] `folke/todo-comments.nvim`?
  - [ ] `uga-rosa/translate.nvim`
  - [ ] `NvChad/nvim-colorizer.lua`
  - [ ] `tpope/vim-repeat`
- [ ] `DAP`
  - <https://www.youtube.com/watch?v=5KQK2id3JtI>
  - <https://www.youtube.com/watch?v=0moS8UHupGc>
- [ ] AI coding assistant
  - [ ] doc
  - [ ] snippets
  - [ ] tests
