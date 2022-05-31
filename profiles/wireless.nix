{ lib
, config
, ...
}:

with lib;

let
  iwd-cfg = config.networking.wireless.iwd;
in
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
            NameResolvingService = mkDefault "systemd";
            EnableIPv6 = mkDefault false;
            RoutePriorityOffset = mkDefault 2048;
          };
        };
      };

      wireless.enable = !iwd-cfg.enable;
      networkmanager.wifi.backend = mkIf iwd-cfg.enable "iwd";
    };

    systemd.network.networks =
      mkIf iwd-cfg.settings.General.EnableNetworkConfiguration {
        "80-iwd" = {
          matchConfig.Type = "wlan";
          linkConfig.Unmanaged = true;
        };
      };

    systemd.services = {
      "iwd" = {
        requires = [ "dbus.service" ];
        after = [ "dbus.service" ];
      };
    };
  };
}
