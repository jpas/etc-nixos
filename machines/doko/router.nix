{ lib, config, ... }

with lib;

let
in
mkIf false {
  # TODO: https://www.jjpdev.com/posts/home-router-nixos/
  # SEE ALSO: https://github.com/tailscale/tailscale/issues/391#issuecomment-1311918712
  # systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

  # networking.nat.enable = true;

  systemd.network.networks = {
    "20-wan" = {
      matchConfig.Name = "enp11s0f3";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        DHCP = "yes";
        IPMasquerade = "ipv4";
        IPv6AcceptRA = true;
      };
      dhcpV4Config = {
        SendHostname = false;
        UseHostname = false;
        UseDNS = false;
        RouteMetric = 512;
      };
      dhcpV6Config = {
        #UseHostname = false;
        #UseDNS = false;
        RouteMetric = 512;
      };
    };
    "21-lan" = {
      matchConfig.Name = "eno5";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        Address = "10.39.3.1/24";
        ConfigureWithoutCarrier = "yes";
        DHCPServer = "yes";
      };
      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 100;
      };
    };
  };

  networking.firewall.interfaces."eno5".allowedUDPPorts = [ 67 ];
}
