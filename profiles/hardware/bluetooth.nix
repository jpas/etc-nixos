{ lib, config, ... }:

with lib;

let
  cfg = config.hardware.bluetooth;
in
{
  hardware.bluetooth.enable = mkDefault true;
  hardware.bluetooth.settings = {
    General = {
      FastConnectable = mkDefault true;
      DiscoverableTimeout = mkDefault 60; # seconds
      PairableTimeout = mkDefault 60; # seconds
    };
  };
}
