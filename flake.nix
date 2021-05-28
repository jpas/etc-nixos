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
    rec {
      lib = nixpkgs.lib.extend (import ./lib);

      nixosConfigurations = lib.flip lib.mapAttrs (import ./machines)
        (name: configuration: lib.flakeSystem {
          # XXX: system extraction relies on configuration a path to an attrset
          system = (import configuration).nixpkgs.system;
          modules = [ configuration ];
        });

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
