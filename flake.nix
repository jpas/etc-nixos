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

      mkSystem = base: lib.nixosSystem rec {
        # XXX: system extraction relies on base configuration being an attrset
        system = (import base).nixpkgs.system;
        modules = [
          base

          ({ ... }: {
            imports = [ self.inputs.home-manager.nixosModules.home-manager ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = lib.attrValues self.hmModules;
            };
          })

          ({ pkgs, ... }: {
            system.configurationRevision = lib.mkIf (self ? rev) self.rev;

            imports = lib.attrValues self.nixosModules;

            nix = {
              package = pkgs.nixUnstable;
              extraOptions = ''
                experimental-features = flakes nix-command
              '';
              nixPath = [
                "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
              ];
            };

            systemd.tmpfiles.rules = [
              "L+ ${self.outPath}/lib/compat/channels - - - /nix/var/nix/profiles/per-user/root/channels"
            ];

            nixpkgs = rec {
              pkgs = self.packages.${system};
              inherit (pkgs) config;
            };
          })
        ];
      };

      importDir = dir:
        lib.mapAttrs
          (subdir: _: dir + "/${subdir}")
          (lib.filterAttrs (_: t: t == "directory") (builtins.readDir dir));

    in
    {
      nixosConfigurations = lib.mapAttrs (_: mkSystem) (importDir ./machines);

      overlays = {
        hole = import ./pkgs;
      };

      hmModules = importDir ./modules/home;
      nixosModules = importDir ./modules/nixos;

      packages = lib.genAttrs (lib.attrNames nixpkgs.legacyPackages)
        (system: import nixpkgs {
          inherit system;
          overlays = lib.attrValues self.overlays;
          config = {
            allowUnfree = true;
          };
        });
    };
}
