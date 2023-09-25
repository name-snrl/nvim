{
  description = "Overlay containing a wrapper around pkgs.neovim-unwrapped";
  outputs = _: {
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
            go
            rust
            starlark
            yuck
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
  };
}
