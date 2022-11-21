{ lib, config, ... }:

with lib;

let
in
mkIf true {
  # TODO: https://www.jjpdev.com/posts/home-router-nixos/
  # SEE ALSO: https://github.com/tailscale/tailscale/issues/391#issuecomment-1311918712
  systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

  #networking.nat = {
  #  enable = true;
  #  externalInterface = "eno6";
  #  internalIPs = [ "10.39.3.0/24" ];
  #  internalInterfaces = [ "eno5" ];
  #};

  systemd.network.networks = {
    "20-wan" = {
      matchConfig.Name = "eno6";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        DHCP = "yes";
        DNS = [
          "1.1.1.1#cloudflare-dns.com"
          "1.0.0.1#cloudflare-dns.com"
          "2606:4700:4700::1111#cloudflare-dns.com"
          "2606:4700:4700::1001#cloudflare-dns.com"
        ];
        IPv6AcceptRA = true;
        IPMasquerade = true;
      };
      dhcpV4Config = {
        SendHostname = false;
        UseHostname = false;
        UseDNS = false;
      };
      dhcpV6Config = {
        #UseHostname = false;
        #UseDNS = false;
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
        IPForward = true;
      };
      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 100;
      };
    };
  };

  networking.firewall.interfaces."eno5".allowedUDPPorts = [ 67 ];
}
