{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs = {
      url = "github:vlaci/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      inherit (nixpkgs) lib;

      mkSystem = base: lib.nixosSystem {
        # XXX: system extraction relies on base configuration being an attrset
        system = base.nixpkgs.system;
        modules = [
          base

          ({ pkgs, ... }: {
            nixpkgs = rec {
              pkgs = self.packages.${base.nixpkgs.system};
              inherit (pkgs) config;
            };

            imports = lib.attrValues self.nixosModules;

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;

            nix = {
              registry = {
                pkgs.flake = self;
                nixpkgs.flake = nixpkgs;
              };

              package = pkgs.nixFlakes;
              extraOptions = ''
                experimental-features = ca-references flakes nix-command
              '';

              nixPath = [
                "nixpkgs=/run/current-system/flake/lib/compat/nixpkgs"
              ];
            };

            system.extraSystemBuilderCmds = ''
              ln -s '${self.outPath}' "$out/flake"
            '';
          })

          ({ ... }: {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              sharedModules = lib.attrValues self.hmModules;
            };
          })
        ];
      };

      importDir = dir:
        lib.mapAttrs
          (subdir: _: import (dir + "/${subdir}"))
          (lib.filterAttrs (_: t: t == "directory") (builtins.readDir dir));

    in
    {
      overlays = {
        hole = import ./pkgs;
      };

      packages = lib.genAttrs (lib.attrNames nixpkgs.legacyPackages)
        (system: import nixpkgs {
          inherit system;
          overlays = lib.attrValues self.overlays;
          config = {
            allowUnfree = true;
          };
        });

      nixosConfigurations = lib.mapAttrs (_: mkSystem) (importDir ./machines);
      hmModules = importDir ./modules/home;
      nixosModules = importDir ./modules/nixos;
    };
}
