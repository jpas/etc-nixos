{ lib, pkgs, config, ... }:

{
  networking.hostName = "doko";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ./factorio.nix
    ./fs.nix
    ./authelia
    ./hardware.nix
    ./jellyfin
    ./networking.nix
    ./traefik
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # TODO: fan control via ipmi?
  # https://github.com/missmah/ipmi_tools/blob/master/ipmi_fancontrol.pl

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
