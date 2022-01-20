{ lib
, config
, ...
}:

with lib;

let
  enable = config.hole.profiles ? wireless;
in
{
  networking = {
    networkmanager.wifi.backend = "iwd";

    wireless.enable = !enable;

    wireless.iwd = {
      inherit enable;

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
  };
}
