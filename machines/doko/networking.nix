{ lib, config, meta, ... }:

with lib;

let
  quoted = s: "\"${s}\"";

  cfg = config.systemd.network;

  forMachinesIn = net: f:
    pipe meta.machines [
      (filterAttrs (_: hasAttrByPath [ "net" net ]))
      (mapAttrs f)
    ];

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
    lan1 = "eno3";
  };
in
{
  services.fail2ban.enable = true;

  systemd.network.networks."20-wan0" = {
    matchConfig.Name = interfaces.wan0;
    linkConfig = {
      MACAddress = "e0:db:d1:27:5e:bd";
      RequiredForOnline = "routable";
    };
    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = false;
    };
    dhcpV4Config = {
      SendHostname = false;
      RouteMetric = 1024;
    };
    dhcpV6Config = {
      #WithoutRA = "solicit";
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
      #IPv6AcceptRA = false;
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

  systemd.network.networks."20-lan0" = {
    matchConfig.Name = interfaces.lan0;
    linkConfig = {
      RequiredForOnline = "routable";
    };
    networkConfig = {
      Address = "10.39.0.254/24";
      DNS = dns;
      DHCPServer = "yes";
      #IPv6SendRA = true;
      #DHCPPrefixDelegation = true;
    };
    dhcpServerConfig = {
      PoolOffset = 100;
      PoolSize = 100;
      DNS = [
        "10.39.0.254"
        #"1.1.1.1#cloudflare-dns.com"
        #"1.0.0.1#cloudflare-dns.com"
      ];
    };
    #dhcpPrefixDelegationConfig = {
    #  UplinkInterface = interfaces.wan0;
    #};
    dhcpServerStaticLeases = attrValues (forMachinesIn "lo" (_: machine: {
      dhcpServerStaticLeaseConfig = {
        Address = machine.net.lo.ipv4;
        MACAddress = machine.net.lo.mac;
      };
    }));
  };

  networking.firewall.interfaces.${interfaces.lan0}.allowedUDPPorts = [
    53 # dns server
    67 # dhcp server
  ];

  systemd.network.networks."20-lan1" = {
    matchConfig.Name = interfaces.lan1;
    networkConfig = {
      Address = "10.39.1.254/24";
    };
  };
  networking.firewall.trustedInterfaces = [ interfaces.lan1 ];

  networking.nat.enable = true;
  networking.nat = {
    externalInterface = interfaces.wan0;
    internalInterfaces = [ interfaces.lan0 ];
  };

  services.unbound.enable = true;
  services.unbound = {
    settings = {
      server = {
        interface = [ "0.0.0.0" ];
        access-control = [ "10.0.0.0/8 allow" ];
        local-zone = [
          "${quoted "lo.pas.sh."} static"
        ];
        local-data = (attrValues (forMachinesIn "lo"
          (name: machine: quoted "${name}.lo.pas.sh. IN A ${machine.net.lo.ipv4}")
        ));
        local-data-ptr = attrValues (forMachinesIn "lo"
          (name: machine: quoted "${machine.net.lo.ipv4} ${name}.lo.pas.sh")
        );
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1"
            "1.0.0.1"
            #"2606:4700:4700::1111"
            #"2606:4700:4700::1001"
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
