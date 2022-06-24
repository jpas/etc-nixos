{ lib, ... }:
{
  networking.hostName = "kado";
  nixpkgs.system = "x86_64-linux";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ./hardware.nix
    ./aleph.nix
    #./trinity.nix
    #./factorio.nix
    ./nfs.nix
    ./print-and-scan.nix
    ./unbound.nix
    ./kresd.nix
    #./samba.nix
    #./croc.nix
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
    5201
    9091 # TODO: transmission
    # jellyfin docker
    8096
    8920
    # sonarr docker
    7878
    # radarr docker
    8989
  ];

  networking.firewall.allowedUDPPorts = [
    5201
    # jellyfin docker
    1900
    7359
  ];

  services.fail2ban.enable = true;
  services.unbound.enable = true;
  virtualisation.docker.enable = true;

  systemd.network.networks = {
    "20-lan" = {
      matchConfig.Name = "enp0s20f0";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        DHCP = "yes";
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = lib.mkForce "22.11"; # Did you read the comment?
}
