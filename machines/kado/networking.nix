{
  services.fail2ban.enable = true;

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

  systemd.network.networks."20-lan0" = {
    matchConfig.Name = "enp0s20f0";
    networkConfig = {
      DHCP = "yes";
    };
  };

  systemd.network.networks."20-lan1" = {
    matchConfig.Name = "enp0s20f1";
    linkConfig = {
      RequiredForOnline = "routable";
    };
    networkConfig = {
      DNS = "10.39.1.254";
      Address = "10.39.1.20/24";
    };
    routes = [
      {
        Gateway = "10.39.1.254";
      }
    ];
  };

  networking.firewall.trustedInterfaces = [ "enp0s20f1" ];
}
