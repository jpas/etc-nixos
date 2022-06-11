{ config, lib, ... }:

with lib;

let

  cfg = config.hole.use;

in
{
  options.hole.use.bluetooth = mkEnableOption "bluetooth";

  config = mkIf cfg.bluetooth {
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
