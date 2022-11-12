{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };

  outputs = { self, nixpkgs, utils, ... } @ inputs:
    let
      inherit (inputs) deploy-rs home-manager;
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
          flakes = self.inputs // { inherit self; };
        };
      };
    in
    with lib;
    {
      overlays.default = import ./pkgs;

      nixosConfigurations = {
        shiro = mkSystem {
          system = "x86_64-linux";
          profiles = [
            ./machines/shiro
            ./profiles/base
          ];
        };

        kuro = mkSystem {
          system = "x86_64-linux";
          profiles = [
            ./machines/kuro
            ./profiles/base
          ];
        };
      };

      deploy = {
        sshUser = "root";
        fastConnection = true;

        nodes = flip mapAttrs self.nixosConfigurations
          (name: machine:
            let system = machine.config.nixpkgs.system; in {
              hostname = "${name}.o";
              profiles.system = {
                user = "root";
                path = deploy-rs.lib.${system}.activate.nixos machine;
              };
            });
      };

      hmModules = let modules = import ./modules/home; in
        modules // { default = { imports = attrValues modules; }; };

      nixosModules = let modules = import ./modules/nixos; in
        modules // { default = { imports = attrValues modules; }; };

      checks = flip mapAttrs deploy-rs.lib
        (system: deployLib: deployLib.deployChecks self.deploy);
    } // eachDefaultSystem (system: pkgs: {
      packages = flip filterAttrs pkgs.hole
        (_: pkg: meta.availableOn pkgs.stdenv.hostPlatform pkg);
    });
}
