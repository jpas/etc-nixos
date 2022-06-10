{ lib
, config
, ...
}:

with lib;

let
  cfg = config.hole.hardware.bluetooth;
in
{
  options.hole.hardware.bluetooth.enable = mkEnableOption "bluetooth";

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;

      settings = {
        General = {
          FastConnectable = mkDefault true;
          DiscoverableTimeout = mkDefault 60; # seconds
          PairableTimeout = mkDefault 60; # seconds
        };
      };
    };
  };
}
