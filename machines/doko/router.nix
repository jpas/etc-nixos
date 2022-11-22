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
    };
    dhcpV4Config = {
      SendHostname = false;
    };
    extraConfig = ''
      [Link]
      MACAddress=e0:db:d1:27:5e:bd
      #MACAddress=0c:c4:7a:93:a5:5e

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

  networking.firewall.interfaces.${interfaces.mgmt}.allowedUDPPorts = [ 67 ];

  systemd.network.networks."20-mgmt" = {
    matchConfig.Name = interfaces.mgmt;
    linkConfig = {
      RequiredForOnline = "routable";
    };
    networkConfig = {
      IPMasquerade = "both";
      Address = "10.39.0.254/24";
      DHCPServer = "yes";
      IPv6SendRA = true;
      DHCPPrefixDelegation = true;
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
