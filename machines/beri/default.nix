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

  hole.use.arm-cpu = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}

