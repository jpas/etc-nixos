{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, deploy-rs, ... } @ inputs:
    let
      lib = nixpkgs.lib.extend (import ./lib);
    in
    {
      inherit lib;

      nixosConfigurations = lib.flip lib.mapAttrs (import ./machines)
        (name: configuration: lib.flakeSystem {
          flake = self;
          # XXX: Assume the system, but we can set it via `nixpkgs.system`
          system = "x86_64-linux";
          modules = [
            configuration
            home-manager.nixosModules.default
          ];
        });

      overlays.default = import ./pkgs;

      packages = lib.genAttrs [ "x86_64-linux" ] (system:
        let
          #install-iso = self.nixosConfigurations.iso.config.system.build.isoImage;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        pkgs.hole #// { inherit install-iso; }
      );

      deploy = {
        nodes = lib.flip lib.mapAttrs self.nixosConfigurations
          (name: configuration: {
            hostname = "${name}.o";
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos configuration;
            };
          });

        user = "jpas";
      };

      hmModules = let modules = import ./modules/home; in
          modules // { default = { imports = lib.attrValues modules; }; };

      nixosModules = let modules = import ./modules/nixos; in
          modules // { default = { imports = lib.attrValues modules; }; };

      checks = lib.flip lib.mapAttrs deploy-rs.lib
        (system: deployLib: deployLib.deployChecks self.deploy);
    };
}
