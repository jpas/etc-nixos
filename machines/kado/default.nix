{ lib, ... }:

{
  networking.hostName = "kado";

  imports = [
    ../../profiles/archetype/minimal
    ../common
    ./fs.nix
    ./hardware.nix
    ./networking.nix
    ./nfs.nix
    ./syncthing.nix
  ];

  virtualisation.docker.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = lib.mkForce "22.11"; # Did you read the comment?
}
