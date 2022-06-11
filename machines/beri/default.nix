{ lib
, config
, pkgs
, ...
}:

with lib;

{
  networking.hostName = "beri";
  nixpkgs.system = "aarch64-linux";

  imports = [ ../common ];

  hole.use = {
    arm-cpu = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
}

