{ lib, config, ... }:

with lib;

let
  interfaces = {
    wan = "eno1";
    mgmt = "eno3";
    lan = "eno4";
  };
in
{
  # TODO: https://www.jjpdev.com/posts/home-router-nixos/
  # SEE ALSO: https://github.com/tailscale/tailscale/issues/391#issuecomment-1311918712
  systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

  # systemd-networkd doesn't set up masquerade properly
  networking.firewall.enable = false;
  networking.nftables.enable = true;
  networking.nftables.ruleset = ''
    table ip nat {
      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;
        oifname ${interfaces.wan} masquerade
      }
    }
  '';

  boot.kernel.sysctl = {
    "net.ipv4.conf.default.forwarding" = 0;
    "net.ipv4.conf.${interfaces.wan}.forwarding" = 1;
    "net.ipv4.conf.${interfaces.mgmt}.forwarding" = 1;

    "net.ipv6.conf.default.forwarding" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;
    "net.ipv6.conf.default.use_tempaddr" = 0;

    "net.ipv6.conf.${interfaces.wan}.accept_ra" = 2;
    "net.ipv6.conf.${interfaces.wan}.autoconf" = 1;
    "net.ipv6.conf.${interfaces.wan}.forwarding" = 1;

    "net.ipv6.conf.${interfaces.mgmt}.forwarding" = 1;
  };

  systemd.network.networks."20-wan" = {
    matchConfig.Name = interfaces.wan;
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
      #IPv6AcceptRA = true;
      #IPMasquerade = true;
      #IPForward = true;
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

  networking.firewall.interfaces.${interfaces.mgmt}.allowedUDPPorts = [ 67 ];

  systemd.network.networks."20-mgmt" = {
    matchConfig.Name = interfaces.mgmt;
    linkConfig = {
      RequiredForOnline = "routable";
    };
    networkConfig = {
      Address = "10.39.0.254/24";
      DHCPServer = "yes";
    };
    dhcpServerConfig = {
      PoolOffset = 100;
      PoolSize = 100;
    };
  };

  systemd.network.networks."20-lan" = {
    matchConfig.Name = interfaces.lan;
    linkConfig = {
      RequiredForOnline = "routable";
    };
    networkConfig = {
      Address = "10.39.0.21/24";
    };
  };
}
