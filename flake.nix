{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      inherit (nixpkgs) lib;

      mkHosts = lib.mapAttrs (_: { config, system }: lib.nixosSystem {
        inherit system;
        modules = [
          config
          inputs.self.nixosModules.flake-compat
          inputs.home-manager.nixosModules.home-manager
        ];
      });
    in
    {
      nixosConfigurations = mkHosts {
        kuro = { config = ./machines/kuro; system = "x86_64-linux"; };
        kado = { config = ./machines/kado; system = "x86_64-linux"; };
      };

      overlay = import ./pkgs/default.nix;

      nixosModules = {
        flake-compat = { pkgs, ... }: {
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
              "nixpkgs=${self}/lib/compat/nixpkgs"
            ];
          };

          nixpkgs.overlays = [ self.overlay ];
        };
      };
    };
}
