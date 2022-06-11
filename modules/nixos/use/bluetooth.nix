{ lib
, config
, ...
}:

with lib;

let
  cfg = config.hole.use.bluetooth;
in
{
  options.hole.use.bluetooth = mkEnableOption "bluetooth";

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
