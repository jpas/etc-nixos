{ lib, config, pkgs, ... }:

with lib;

{
  networking.wireless.iwd.enable = mkDefault true;

  networking.wireless.enable = mkDefault false;
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

  environment.systemPackages = [ pkgs.iw ];
}
