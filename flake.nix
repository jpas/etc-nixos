{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      inherit (nixpkgs) lib;

      systems = lib.attrNames nixpkgs.legacyPackages;

      forAllSystems = f: lib.genAttrs systems (system: f system);

      machines = lib.mapAttrs (name: { system, config }: lib.nixosSystem {
        inherit system;
        modules = [
          inputs.home-manager.nixosModules.home-manager
          config
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
            };

            nixpkgs = {
              overlays = [ self.overlay ];
            };
          })
        ];
      });
    in
    {
      nixosConfigurations = machines {
        kuro = { config = ./machines/kuro; system = "x86_64-linux"; };
        kado = { config = ./machines/kado; system = "x86_64-linux"; };
      };

      nixosModules = {
      };

      overlay = import ./pkgs/overlay.nix;

      packages = forAllSystems (system:
        import ./pkgs/default.nix {
          pkgs = import nixpkgs { inherit system; };
        }
      );
    };
}
