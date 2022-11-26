{ lib, pkgs, config, ... }:

{
  networking.hostName = "doko";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ./authelia.nix
    ./factorio.nix
    ./fs.nix
    ./hardware.nix
    ./influx.nix
    ./jellyfin.nix
    ./networking.nix
    ./radarr.nix
    ./sonarr.nix
    ./traefik.nix
    ./unifi.nix
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
