{ lib, pkgs, ... }:

with lib;

{
  services.ratbagd.enable = mkDefault true;
  environment.systemPackages = [ pkgs.piper ];
}
