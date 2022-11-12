{ lib, flakes, ... }:

{
  imports = [ flakes.home-manager.nixosModules.default ];

  home-manager = {
    useGlobalPkgs = lib.mkForce true;
    useUserPackages = lib.mkForce true;
    sharedModules = [
      (flakes.self.hmModules.default or { })
      ./home-manager
    ];
  };
}
