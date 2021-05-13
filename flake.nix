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

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      inherit (nixpkgs) lib;

      systems = lib.attrNames nixpkgs.legacyPackages;

      forAllSystems = f: lib.genAttrs systems (system: f system);


      flake-compat = ({ pkgs, ... }: {
        system.configurationRevision =
          if self ? rev
          then self.rev
          else "${lib.substring 0 8 self.lastModifiedDate}-dirty";

          nix = {
            package = pkgs.nixFlakes;
            extraOptions = ''
              experimental-features = nix-command flakes ca-references
            '';
            nixPath = [
              "nixpkgs=${self}/lib/compat/nixpkgs"
            ];
          };
      });

      machines = lib.mapAttrs (name: { system, config }: lib.nixosSystem {
        inherit system;
        modules = [
          inputs.home-manager.nixosModules.home-manager
          config
          flake-compat
        ];
      });
    in
    {
      inherit lib;

      nixosConfigurations = machines {
        kuro = { config = ./machines/kuro; system = "x86_64-linux"; };
        kado = { config = ./machines/kado; system = "x86_64-linux"; };
      };

      nixosModules = { };

      overlay = import ./pkgs/default.nix;

      packages = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        });
    };
}
