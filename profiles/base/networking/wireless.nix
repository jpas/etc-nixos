{ lib, config, pkgs, ... }:

with lib;

mkIf config.networking.wireless.iwd.enable {
  environment.systemPackages = [ pkgs.iw ];

  networking.wireless.enable = false;
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

  networking.networkmanager.wifi.backend = "iwd";

  systemd.services."iwd" = {
    requires = [ "dbus.service" ];
    after = [ "dbus.service" ];
  };

  systemd.network.networks."60-iwd" = {
    matchConfig.Type = "wlan";
    linkConfig.Unmanaged = true;
  };
}

