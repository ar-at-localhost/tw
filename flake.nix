{
  description = "tw - Neovim Theme Watcher";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    pog = {
      url = "github:jpetrucciani/pog";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ldx = {
      url = "github:ar-at-localhost/ldx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yalms = {
      url = "github:ar-at-localhost/yalms";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    inherit (inputs.nixpkgs) lib;

    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forEachSupportedSystem = f:
      lib.genAttrs supportedSystems (
        system:
          f {
            inherit self system;
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.pog.overlays.default
                inputs.ldx.overlays.default
                inputs.yalms.overlays.default
              ];
            };
          }
      );

    mkOutputs = pkgs: {
      default = pkgs.callPackage ./vim-plugin.nix {};
    };
  in {
    devShells = forEachSupportedSystem (
      {pkgs, ...}: {
        default = pkgs.mkShell {
          packages = with pkgs; [alejandra ldx];
          shellHook = ''
            ldx sync
            eval $(ldx env)
          '';
        };
      }
    );

    packages = forEachSupportedSystem (
      {pkgs, ...}: mkOutputs pkgs
    );

    overlays.default = final: prev: (let
      outputs = mkOutputs prev;
    in {
      vimPlugins =
        prev.vimPlugins
        // {
          tw = outputs.vimPlugin;
        };
    });

    checks = forEachSupportedSystem (
      {pkgs, ...}: mkOutputs pkgs
    );

    nixvimModules.tw = ./nixvim.nix;
  };
}
