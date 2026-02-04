{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    utils.url = "github:numtide/flake-utils";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, utils, ... }:
    let
      inherit (nixpkgs) lib;

      eachDefaultSystem = f: utils.lib.eachDefaultSystem
        (system: f system (import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        }));

      mkSystem = { system, profiles ? [ ] }: lib.nixosSystem {
        inherit system;
        modules = map import profiles;
        specialArgs = {
          inherit inputs;
          meta = builtins.fromTOML (builtins.readFile ./meta.toml);
        };
      };

    in
    with lib;
    (eachDefaultSystem (system: pkgs: {
      packages = flip filterAttrs pkgs.hole
        (_: pkg: meta.availableOn pkgs.stdenv.hostPlatform pkg);

      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nixpkgs-fmt
          inputs.agenix.packages.${system}.agenix
        ];
      };
    })) // {
      overlays.default = import ./pkgs;

      nixosConfigurations = {
        naze = mkSystem {
          system = "x86_64-linux";
          profiles = [ ./machines/naze ];
        };

        niji = mkSystem {
          system = "x86_64-linux";
          profiles = [ ./machines/niji ];
        };

        shiro = mkSystem {
          system = "x86_64-linux";
          profiles = [ ./machines/shiro ];
        };

        kuro = mkSystem {
          system = "x86_64-linux";
          profiles = [ ./machines/kuro ];
        };

        kado = mkSystem {
          system = "x86_64-linux";
          profiles = [ ./machines/kado ];
        };

        doko = mkSystem {
          system = "x86_64-linux";
          profiles = [ ./machines/doko ];
        };

        beri = mkSystem {
          system = "aarch64-linux";
          profiles = [ ./machines/beri ];
        };
      };

      images = pipe self.nixosConfigurations [
        (filterAttrs (_: machine: machine.config.system.build ? sdImage))
        (mapAttrs    (_: machine: machine.config.system.build.sdImage))
      ];

      nixosModules = let modules = import ./modules; in
        modules // { default = { imports = attrValues modules; }; };
    };
}
