{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... } @ inputs: let
    inherit (inputs) deploy-rs home-manager;

    lib = nixpkgs.lib.extend (import ./lib);

    eachDefaultSystem = f: utils.lib.eachDefaultSystem
      (system: f system (import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      }));
  in
  with lib;
  {
    inherit lib;

    overlays.default = import ./pkgs;

    nixosConfigurations = flip mapAttrs (import ./machines)
      (name: configuration: flakeSystem {
        flake = self;
        # XXX: Assume the system, but we can set it via `nixpkgs.system`
        system = "x86_64-linux";
        modules = [
          configuration
          home-manager.nixosModules.default
        ];
      });

    deploy = {
      sshUser = "root";
      fastConnection = true;

      nodes = flip mapAttrs self.nixosConfigurations
        (name: machine: let system = machine.config.nixpkgs.system; in {
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
