{ lib, flake, ... }:

lib.mkIf (flake.inputs ? home-manager) {
  imports = [ flake.inputs.home-manager.nixosModules.default ];

  home-manager = {
    useGlobalPkgs = lib.mkForce true;
    useUserPackages = lib.mkForce true;
    sharedModules = [ (flake.hmModules.default or { }) ];
  };
}
