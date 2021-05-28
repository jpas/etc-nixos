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
      inherit (self) lib;

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
                experimental-features = ca-references flakes nix-command
              '';
              nixPath = [
                "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                "/nix/var/nix/profiles/per-user/root/channels"
              ];
              registry = {
                hole.flake = self;
                nixpkgs.flake = nixpkgs;
              };
            };

            system.activationScripts =
              let
                overlays = pkgs.writeTextFile {
                  name = "overlays";
                  text = ''
                    (builtins.getFlake "${self.outPath}").overlay
                  '';
                  destination = "/overlays.nix";
                };

                channels = pkgs.linkFarm "flake-legacy-compat" [
                  { name = "nixos"; path = nixpkgs; }
                  { name = "nixpkgs-overlays"; path = overlays; }
                ];
              in
              {
                flake-legacy-compat.text = ''
                  ln --symbolic --force --no-target-directory --no-dereference \
                    ${channels} /nix/var/nix/profiles/per-user/root/channels
                '';
              };

            nixpkgs = rec {
              pkgs = self.legacyPackages.${system};
              inherit (pkgs) config;
            };
          })

          ({ lib, pkgs, ... }: {
            # FIXME: workaround https://github.com/NixOS/nixpkgs/issues/124215
            documentation.info.enable = lib.mkForce false;
          })
        ];
      };
    in
    {
      lib = nixpkgs.lib.extend (import ./lib);

      nixosConfigurations = lib.mapAttrs (_: mkSystem) (import ./machines);

      overlay = import ./pkgs;

      hmModules = (import ./modules/home);
      nixosModules = (import ./modules/nixos);

      legacyPackages = lib.genAttrs (lib.attrNames nixpkgs.legacyPackages)
        (system: import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
          config = {
            allowUnfree = true;
          };
        });
    };
}
