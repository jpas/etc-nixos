{ lib, config, pkgs, ... }:

with lib;

{
  services.hardware.bolt.enable = mkDefault true;
}
