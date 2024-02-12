{
  description = "Overlay containing a wrapper around pkgs.neovim-unwrapped";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nvim-nightly = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nvim-nightly }: {
    overlays.default = final: prev:
      let
        repo = "https://github.com/name-snrl/nvim";
        extraBinPath = with final; [
          gnumake # for required telescope-fzf-native.nvim
          gcc # for required telescope-fzf-native.nvim
          curl # for required translate.nvim
          fd # for required telescope.nvim
          ripgrep # for required telescope.nvim
          zoxide # for required telescope-zoxide
        ];
        extraTSParsers =
          with final.vimPlugins.nvim-treesitter-parsers; [
            fish
            vim
            go
            c
            rust
            starlark
            css
            yaml
            dockerfile
          ];
      in
      rec {
        nvim = final.callPackage ./wrapper.nix { };

        nvim-vanila = nvim.override {
          extraName = "-vanila";
          viAlias = true;
          inherit repo;
          inherit extraBinPath;
        };

        nvim-light = nvim.override {
          extraName = "-light";
          viAlias = true;
          withPython3 = true;
          withLua = true;
          withNix = true;
          withBash = true;
          inherit repo;
          inherit extraBinPath;
          inherit extraTSParsers;
        };

        nvim-full = nvim.override {
          extraName = "-full";
          viAlias = true;
          withPython3 = true;
          withLua = true;
          withNix = true;
          withBash = true;
          withScala = true;
          withMarkdown = true;
          inherit repo;
          inherit extraBinPath;
          inherit extraTSParsers;
        };
      };
  } //
  flake-utils.lib.eachDefaultSystem (system: with import nixpkgs
    {
      inherit system;
      overlays = [
        self.overlays.default
        (final: prev: {
          neovim-unwrapped = nvim-nightly.packages.${final.system}.neovim;
        })
      ];
    };
  {
    devShells.default = mkShellNoCC {
      packages = [ nvim-full ];
    };
  });
}
