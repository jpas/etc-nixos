{ lib
, config
, ...
}:

{
  options.hole.hardware.bluetooth = mkEnableOption "bluetooth";

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
