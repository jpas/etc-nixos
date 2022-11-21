{ lib, pkgs, config, ... }:

{
  networking.hostName = "doko";
  nixpkgs.system = "x86_64-linux";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ./router.nix
    ./coredns.nix
    ./dl.nix
    ./factorio.nix
    ./hardware.nix
    ./srht.nix
    ./traefik.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
