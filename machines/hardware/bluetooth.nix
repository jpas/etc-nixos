{ lib
, ...
}:

with lib;

{
  hardware.bluetooth = {
    enable = mkDefault true;
    settings = {
      General = {
        FastConnectable = mkDefault true;
        DiscoverableTimeout = mkDefault 60; # seconds
        PairableTimeout = mkDefault 60; # seconds
      };
    };
  };
}
