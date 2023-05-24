{ lib, pkgs, config, ... }:

{
  networking.hostName = "doko";
  boot.loader.systemd-boot.enable = true;

  imports = [
    ../../profiles/archetype/minimal
    ../common
    ./acme.nix
    ./authelia.nix
    ./factorio.nix
    ./fs.nix
    ./hardware.nix
    ./influx.nix
    ./jellyfin.nix
    ./kanidm.nix
    ./lldap.nix
    ./networking.nix
    ./ocis.nix
    ./radarr.nix
    ./sonarr.nix
    ./traefik.nix
    ./unifi.nix
  ];

  services.lldap.enable = true;

  services.caddy.enable = true;
  services.traefik.enable = false;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # TODO: fan control via ipmi?
  # https://github.com/missmah/ipmi_tools/blob/master/ipmi_fancontrol.pl

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
