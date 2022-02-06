{ lib
, config
, ...
}:

with lib;

{
  networking = mkIf (config.hole.profiles ? wireless) {
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
}
