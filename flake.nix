{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    utils.url = "github:numtide/flake-utils";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };

  outputs = { self, nixpkgs, utils, ... } @ inputs:
    let
      inherit (inputs) deploy-rs;
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
          meta = builtins.fromTOML (builtins.readFile ./meta.toml);
          flakes = self.inputs // { inherit self; };
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
          inputs.deploy-rs.packages.${system}.deploy-rs
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

      deploy = {
        sshUser = "root";
        fastConnection = true;

        nodes = flip mapAttrs self.nixosConfigurations
          (name: machine:
            let system = machine.config.nixpkgs.system; in {
              hostname = "${name}.o.pas.sh";
              profiles.system = {
                user = "root";
                path = deploy-rs.lib.${system}.activate.nixos machine;
              };
            });
      };

      nixosModules = let modules = import ./modules; in
        modules // { default = { imports = attrValues modules; }; };

      checks = flip mapAttrs deploy-rs.lib
        (system: deployLib: deployLib.deployChecks self.deploy);
    };
}
