{ config, lib, pkgs, ... }:

let

  cfg = config.hole.network.wifi;

in

{
  options = {
    hole.network.wifi = {
      enable = lib.mkEnableOption "wifi";
      dhcp = lib.mkEnableOption "iwd managed dhcp";
    };
  };

  config = lib.mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ pkgs.iw ];

      networking = {
        wireless.iwd.enable = true;
        wireless.enable = false;
        networkmanager.wifi.backend = "iwd";
      };

      systemd.services = {
        "iwd" = {
          requires = [ "dbus.service" ];
          after = [ "dbus.service" ];
        };
      };
    }

    (lib.mkIf cfg.dhcp {
      systemd.network.networks = {
        "60-iwd-dhcp" = {
          matchConfig.Type = "wlan";
          linkConfig.Unmanaged = true;
        };
      };

      networking.wireless.iwd.settings = {
        General = {
          EnableNetworkConfiguration = true;
        };
        Network = {
          NameResolvingService = "systemd";
          EnableIPv6 = true;
          RoutePriorityOffset = 1025; # should be just lower than wired
        };
      };
    });
  ])
}
