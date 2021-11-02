{ lib
, config
, ...
}:

with lib;

let
  enable = config.hole.profiles ? bluetooth;
in
{
  hardware.bluetooth = {
    inherit enable;

    settings = {
      General = {
        FastConnectable = mkDefault true;
        DiscoverableTimeout = mkDefault 60; # seconds
        PairableTimeout = mkDefault 60; # seconds
      };
    };
  };
}
