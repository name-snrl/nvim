{
  description = "Overlay containing a wrapper around pkgs.neovim-unwrapped";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { inputs, ... }:
      {
        imports = with inputs; [
          flake-parts.flakeModules.easyOverlay
          pre-commit-hooks-nix.flakeModule
          treefmt-nix.flakeModule
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
        perSystem =
          { config, pkgs, ... }:
          let
            nvim = pkgs.callPackage ./wrapper.nix { };
            selene-wrapped = pkgs.writeShellScriptBin "selene" ''
              exec ${pkgs.selene}/bin/selene --config ${./selene}/selene.toml "$@"
            '';
          in
          {
            packages = {
              inherit nvim selene-wrapped;
            };
            overlayAttrs = {
              inherit nvim selene-wrapped;
            };

            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                nixfmt-rfc-style.enable = true;
                deadnix.enable = true;
                statix.enable = true; # fix, if possible
                stylua.enable = true;
                mdformat.enable = true;
                mdformat.package = pkgs.mdformat.withPlugins (
                  p: with p; [
                    mdformat-gfm
                    mdformat-frontmatter
                    mdformat-footnote
                  ]
                );
              };
              settings.formatter.mdformat.options = [
                "--wrap"
                "80"
              ];
            };

            pre-commit.settings = {
              hooks = {
                treefmt.enable = true;
                statix.enable = true; # check. not everything can be fixed, but we need to know what
                selene = {
                  enable = true;
                  name = "selene";
                  description = "An opinionated Lua code linter";
                  entry = "${selene-wrapped}/bin/selene";
                  types = [ "lua" ];
                };
              };
              settings.treefmt.package = config.treefmt.build.wrapper;
            };

            devShells.default =
              with pkgs;
              mkShellNoCC {
                packages = [
                  (writeShellApplication {
                    name = "update";
                    text = ''
                      nix flake update \
                          --commit-lock-file \
                          --inputs-from self \
                          --override-input nixpkgs nixpkgs &&
                          direnv reload
                    '';
                  })
                ];
                shellHook = config.pre-commit.installationScript;
              };
          };
      }
    );
}
