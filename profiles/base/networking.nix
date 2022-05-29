{ lib
, config
, ...
}:

with lib;

{
  networking = {
    useNetworkd = mkDefault true;
    useDHCP = mkIf config.networking.useNetworkd false;
  };

  systemd.network.links = {
    "00-persistent-names" = {
      matchConfig.Name = "*";
      linkConfig = {
        NamePolicy = "keep kernel database onboard slot path mac";
        AlternativeNamesPolicy = "database onboard slot path mac";
      };
    };
  };

  systemd.network.networks = {
    "81-ethernet" = {
      matchConfig.Type = "ether";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        DHCP = "yes";
      };
      dhcpV4Config = {
        RouteMetric = 1024;
      };
    };
  };
}
