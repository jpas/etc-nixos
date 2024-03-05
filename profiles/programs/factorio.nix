{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.factorio ];
  networking.firewall.allowedUDPPorts = [ 34197 ];
}
