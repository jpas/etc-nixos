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
      matchConfig.Name = "eno1";
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

    "21-wan" = {
      matchConfig.Name = "eno3";
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
      extraConfig = ''
        [Link]
        MACAddress=e0:db:d1:27:5e:bd
        [DHCPv4]
	IAID=0xd1275ebd
	DUIDType=link-layer
        #RequestOptions=1 2 3 6 12 15 28 42 122 125
        #VendorClassIdentifier=eRouter1.0
        #SendVendorOption=43:string:\x02\x07\x45\x52\x4f\x55\x54\x45\x52\x03\x0c\x45\x52\x4f\x55\x54\x45\x52\x3a\x45\x44\x56\x41
        #SendOption=125:string:\x00\x00\x11\x8b\x07\x01\x02\x7b\x7c\x7c\x01\x07
      '';
    };

    #"20-mgmt" = {
    #  matchConfig.Name = "eno2";
    #  linkConfig = {
    #    RequiredForOnline = "routable";
    #  };
    #  networkConfig = {
    #    Address = "10.39.0.1/23";
    #    ConfigureWithoutCarrier = "yes";
    #    DHCPServer = "yes";
    #    IPForward = true;
    #  };
    #  dhcpServerConfig = {
    #    PoolOffset = 256;
    #    PoolSize = 254;
    #  };
    #};
    #"20-lan" = {
    #  matchConfig.Name = "eno3";
    #  linkConfig = {
    #    RequiredForOnline = "routable";
    #  };
    #  networkConfig = {
    #    Address = "10.39.2.1/24";
    #    ConfigureWithoutCarrier = "yes";
    #    DHCPServer = "yes";
    #    IPForward = true;
    #  };
    #  dhcpServerConfig = {
    #    PoolOffset = 100;
    #    PoolSize = 100;
    #  };
    #};
  };

  networking.firewall.interfaces."eno5".allowedUDPPorts = [ 67 ];
}
