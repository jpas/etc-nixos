{ lib
, config
, pkgs
, ...
}:

with lib;

{
  networking.hostName = "beri";
  nixpkgs.system = "aarch64-linux";
  boot.loader.generic-extlinux-compatible.enable = true;

  imports = [ ../common ];

  hole.profiles = {
    minimal = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
}

