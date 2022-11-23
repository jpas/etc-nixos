{ lib, ... }:
{
  networking.hostName = "kado";
  nixpkgs.system = "x86_64-linux";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ./aleph.nix
    ./print-and-scan.nix
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7932c7d2-49c2-453b-a406-4a73509a57fd";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/E914-BBE6";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/f1476467-c295-47c7-8d0b-51dbcaf182dd"; }
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = lib.mkForce "22.11"; # Did you read the comment?
}
