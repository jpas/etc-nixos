{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include machine specific configuration.
      ./conf/machine/NAME.nix
    ];
}
