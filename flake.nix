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

      mkSystem = name: config: lib.nixosSystem {
        # XXX: system extraction relies on config being an attrset
        system = config.nixpkgs.system;
        modules = [
          ({ pkgs, ... }: {
            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
            nix = {
              registry = {
                hole.flake = self;
                nixpkgs.flake = nixpkgs;
              };

              package = pkgs.nixFlakes;
              extraOptions = ''
                experimental-features nix-command flakes
              '';

              nixPath = [
                "nixpkgs=/run/current-system/nixpkgs"
                "nixpkgs-overlays=/run/current-system/flake/pkgs"
              ];
            };

            system.extraSystemBuilderCmds = ''
              ln -s '${nixpkgs.outPath}' "$out/nixpkgs"
              ln -s '${self.outPath}' "$out/flake"
            '';

            imports = lib.attrValues self.nixosModules;
            nixpkgs.overlays = [ self.overlay ];
          })

          ({ ... }: {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              sharedModules = lib.attrValues self.hmModules;
            };
          })

          config
        ];
      };

      importDir = dir:
        lib.mapAttrs
          (subdir: _: import (dir + "/${subdir}"))
          (lib.filterAttrs (_: t: t == "directory") (builtins.readDir dir));

    in
    {
      nixosConfigurations = lib.mapAttrs mkSystem (importDir ./machines);

      overlay = import ./pkgs;

      hmModules = importDir ./modules/home;
      nixosModules = importDir ./modules/nixos;
    };
}
