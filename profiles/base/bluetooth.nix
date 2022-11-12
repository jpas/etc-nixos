{ lib, config, ... }:

with lib;

{
  hardware.bluetooth.settings = {
    General = {
      FastConnectable = mkDefault true;
      DiscoverableTimeout = mkDefault 60; # seconds
      PairableTimeout = mkDefault 60; # seconds
    };
  };
}
