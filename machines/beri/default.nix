{ lib
, config
, ...
}:

with lib;

{
  networking.hostName = "beri";
  nixpkgs.system = lib.mkForce "aarch64-linux";

  imports = [ ../common ];

  hole.profiles = {
    minimal = true;
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
}

