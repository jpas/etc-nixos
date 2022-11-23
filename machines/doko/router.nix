{ lib, config, ... }:

with lib;

let
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

  mkStaticLeases = mapAttrsToList (_: config: {
    dhcpServerStaticLeaseConfig = config;
  });
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
      IPMasquerade = "both";
      IPv6SendRA = true;
      DHCPPrefixDelegation = true;
    };
    dhcpServerConfig = {
      PoolOffset = 100;
      PoolSize = 100;
    };
    dhcpPrefixDelegationConfig = {
      UplinkInterface = interfaces.wan0;
    };
    dhcpServerStaticLeases = mkStaticLeases {
      uck = { Address = "10.39.0.2"; MACAddress = "fc:ec:da:d0:eb:a3"; };
      usw = { Address = "10.39.0.5"; MACAddress = "b4:fb:e4:19:bd:87"; };
      uap = { Address = "10.39.0.10"; MACAddress = "80:2a:a8:43:89:72"; };

      kado-ipmi = { Address = "10.39.0.30"; MACAddress = "0c:c4:7a:6e:1c:33"; };
      doko-ipmi = { Address = "10.39.0.31"; MACAddress = "0c:c4:7a:93:9d:11"; };

      kado = { Address = "10.39.0.20"; MACAddress = "0c:c4:7a:6a:cd:04"; };
      kuro = { Address = "10.39.0.50"; MACAddress = "34:2e:b7:de:f9:09"; };
      shiro = { Address = "10.39.0.51"; MACAddress = "54:04:a6:0a:57:0e"; };
      haiiro = { Address = "10.39.0.60"; MACAddress = "68:54:5a:94:4e:e0"; };
    };
  };

  networking.firewall.interfaces.${interfaces.lan0}.allowedUDPPorts = [
    67 # dhcp server
  ];
}
