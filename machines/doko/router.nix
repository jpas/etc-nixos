{ lib, config, ... }:

with lib;

let
  quoted = s: "\"${s}\"";

  cfg = config.systemd.network;

  dns = [
    "1.1.1.1#cloudflare-dns.com"
    "1.0.0.1#cloudflare-dns.com"
    "2606:4700:4700::1111#cloudflare-dns.com"
    "2606:4700:4700::1001#cloudflare-dns.com"
  ];

  interfaces = {
    wan0 = "eno1";
    wan1 = "eno4";
    lan0 = "eno2";
  };

  hosts = [
    { name = "uck.lo"; ipv4 = "10.39.0.2"; mac = "fc:ec:da:d0:eb:a3"; }
    { name = "usw.lo"; ipv4 = "10.39.0.5"; mac = "b4:fb:e4:19:bd:87"; }
    { name = "uap.lo"; ipv4 = "10.39.0.10"; mac = "80:2a:a8:43:89:72"; }

    { name = "kado.lo"; ipv4 = "10.39.0.20"; mac = "0c:c4:7a:6a:cd:04"; }
    { name = "kado.o"; ipv4 = "100.65.152.104"; }
    { name = "ipmi.kado.lo"; ipv4 = "10.39.0.30"; mac = "0c:c4:7a:6e:1c:33"; }

    { name = "doko.lo"; ipv4 = "10.39.0.254"; mac = "0c:c4:7a:93:a5:5f"; }
    { name = "doko.o"; ipv4 = "100.68.33.127"; }
    { name = "ipmi.doko.lo"; ipv4 = "10.39.0.31"; mac = "0c:c4:7a:93:9d:11"; }

    { name = "haiiro.lo"; ipv4 = "10.39.0.60"; mac = "68:54:5a:94:4e:e0"; }
    { name = "haiiro.o"; ipv4 = "100.91.221.11"; }

    { name = "kuro.lo"; ipv4 = "10.39.0.50"; mac = "34:2e:b7:de:f9:09"; }
    { name = "kuro.o"; ipv4 = "100.116.4.62"; }

    { name = "shiro.lo"; ipv4 = "10.39.0.51"; mac = "54:04:a6:0a:57:0e"; }
    { name = "shiro.o"; ipv4 = "100.69.65.63"; }
  ];
in
{
  systemd.network.networks."20-wan0" = {
    matchConfig.Name = interfaces.wan0;
    linkConfig = {
      MACAddress = "e0:db:d1:27:5e:bd";
      RequiredForOnline = "routable";
    };
    networkConfig = {
      DNS = dns;
      DHCP = "yes";
    };
    dhcpV4Config = {
      SendHostname = false;
      RouteMetric = 1024;
    };
    dhcpV6Config = {
      WithoutRA = "solicit";
    };
    extraConfig = ''
      [DHCPv4]
      IAID=0xd1275ebd
      DUIDType=link-layer
      #RequestOptions=1 2 3 6 12 15 28 42 122 125
      #VendorClassIdentifier=eRouter1.0
      #SendVendorOption=43:string:\x02\x07\x45\x52\x4f\x55\x54\x45\x52\x03\x0c\x45\x52\x4f\x55\x54\x45\x52\x3a\x45\x44\x56\x41
      #SendOption=125:string:\x00\x00\x11\x8b\x07\x01\x02\x7b\x7c\x7c\x01\x07

      UseDNS=false
      UseDomains=false
      UseHostname=false
      UseNTP=false

      [DHCPv6]
      IAID=0x01
      DUIDType=link-layer

      UseDNS=false
      UseDomains=false
      UseHostname=false
      UseNTP=false
    '';
  };

  systemd.network.networks."20-wan1" = {
    matchConfig.Name = interfaces.wan1;
    linkConfig = {
      RequiredForOnline = "no";
    };
    networkConfig = {
      DNS = dns;
      DHCP = "ipv4";
      IPv6AcceptRA = false;
    };
    dhcpV4Config = {
      SendHostname = false;
      UseDNS = false;
      UseDomains = false;
      UseHostname = false;
      UseNTP = false;
      RouteMetric = cfg.networks."20-wan0".dhcpV4Config.RouteMetric + 1;
    };
  };

  systemd.network.networks."20-lan" = {
    matchConfig.Name = interfaces.lan0;
    linkConfig = {
      RequiredForOnline = "routable";
    };
    networkConfig = {
      Address = "10.39.0.254/24";
      DNS = dns;
      DHCPServer = "yes";
      IPv6SendRA = true;
      DHCPPrefixDelegation = true;
    };
    dhcpServerConfig = {
      PoolOffset = 100;
      PoolSize = 100;
      DNS = [
        "10.39.0.254"
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
      ];
    };
    dhcpPrefixDelegationConfig = {
      UplinkInterface = interfaces.wan0;
    };
    dhcpServerStaticLeases = pipe hosts [
      (filter (host: host ? mac))
      (map (host: {
        dhcpServerStaticLeaseConfig = {
          Address = host.ipv4;
          MACAddress = host.mac;
        };
      }))
    ];
  };

  networking.firewall.interfaces.${interfaces.lan0}.allowedUDPPorts = [
    53 # dns server
    67 # dhcp server
  ];

  networking.nat.enable = true;
  networking.nat = {
    externalInterface = interfaces.wan0;
    internalInterfaces = [ interfaces.lan0 ];
  };

  services.unbound.enable = true;
  services.unbound = {
    settings = {
      server = {
        interface = [ "0.0.0.0" "::1" ];
        access-control = [ "10.0.0.0/8 allow" ];
        local-zone = [
          "${quoted "lo."} static"
          "${quoted "o."} static"
        ];
        local-data = pipe hosts [
          (filter (host: (hasSuffix ".lo" host.name) || (hasSuffix ".o" host.name)))
          (map (host: quoted "${host.name}. IN A ${host.ipv4}"))
        ];
        local-data-ptr = pipe hosts [
          (filter (host: hasSuffix "lo" host.name))
          (map (host: quoted "${host.ipv4} ${host.name}"))
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1"
            "1.0.0.1"
            "2606:4700:4700::1111"
            "2606:4700:4700::1001"
          ];
        }
      ];
    };
  };

  services.resolved.extraConfig = mkIf config.services.unbound.enable ''
    [Resolve]
    DNS=127.0.0.1
    DNSStubListener=no
  '';
}
