{ lib, ... }:

with lib;

{
  imports = [
    ../base
    ../workstation
    ./power.nix
  ];

  hardware.bluetooth.enable = mkDefault true;
  networking.wireless.iwd.enable = mkDefault true;
}
