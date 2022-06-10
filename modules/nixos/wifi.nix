{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.hole.hardware.wireless;
  iwd-cfg = config.networking.wireless.iwd;
in
{
  options.hole.hardware.wifi.enable = mkEnableOption "wifi";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.iw ];

    networking = {
      wireless.iwd = {
        enable = mkDefault true;

        settings = {
          General = {
            EnableNetworkConfiguration = config.hole.networking.dhcp;
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
      mkIf config.hole.networking.dhcp {
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
