{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
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
            home-manager.nixosModule
          ];
        });

      overlays.default = import ./pkgs;

      packages = lib.genAttrs [ "x86_64-linux" ] (system:
        let
          install-iso = self.nixosConfigurations.iso.config.system.build.isoImage;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        pkgs.hole // { inherit install-iso; }
      );

      hmModule = { imports = lib.attrValues self.hmModules; };
      hmModules = import ./modules/home;

      nixosModule = { imports = lib.attrValues self.nixosModules; };
      nixosModules = import ./modules/nixos;
    };
}
