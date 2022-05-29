{ lib
, config
, ...
}:

with lib;

{
  config = mkIf (config.hole.profiles ? wireless) {
    networking = {
      wireless.iwd = {
        enable = mkDefault true;

        settings = {
          General = {
            EnableNetworkConfiguration = mkDefault true;
          };
          Network = {
            EnableIPv6 = mkDefault false;
            RoutePriorityOffset = mkDefault 2048;
          };
        };
      };

      wireless.enable = !config.networking.wireless.iwd.enable;
      networkmanager.wifi.backend = mkIf config.wireless.iwd.enable "iwd";
    };

    systemd.network.networks = {
      "81-wlan" = {
        matchConfig = {
          Type = "wlan";
        };
        linkConfig = {
          RequiredForOnline = "routable";
        };
      };
    };

    systemd.services = {
      "iwd" = {
        requires = [ "dbus.service" ];
        after = [ "dbus.service" ];
        bindsTo = [ "systemd-networkd.service" ];
      };
    };
  };
}
