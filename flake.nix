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

      mkHosts = lib.mapAttrs (_: { config, system }: lib.nixosSystem {
        inherit system;
        modules = (lib.attrValues self.nixosModules) ++ [
          config
          inputs.home-manager.nixosModule
          ({ pkgs, ... }: {
            system.configurationRevision =
              if self ? rev
              then self.rev
              else "${lib.substring 0 8 self.lastModifiedDate}-dirty";

            nix = {
              package = pkgs.nixFlakes;
              extraOptions = ''
                experimental-features = nix-command flakes
              '';
              nixPath = [
                "nixpkgs=/etc/nix/flake/lib/compat/nixpkgs"
              ];
            };

            environment.etc."nix/flake" = {
              source = "${self}";
            };

            nixpkgs.overlays = [ self.overlay (import inputs.emacs-overlay) ];

            home-manager = {
              useGlobalPkgs = lib.mkDefault true;
              useUserPackages = lib.mkDefault false;
              sharedModules = (lib.attrValues self.homeModules) ++ [
                inputs.nix-doom-emacs.hmModule
                ({ ... }: {
                  home.file.".nix-defexpr/nixos.nix" = {
                    text = "import <nixpkgs> { }";
                  };
                })
              ];
            };
          })
        ];
      });

      mkModules = lib.mapAttrs (_: module: import module);
    in
    {
      nixosConfigurations = mkHosts {
        kuro = { config = ./machines/kuro; system = "x86_64-linux"; };
        kado = { config = ./machines/kado; system = "x86_64-linux"; };
      };

      overlay = import ./pkgs;

      homeModules = mkModules (import ./modules/home);
      nixosModules = mkModules (import ./modules/nixos);
    };
}
