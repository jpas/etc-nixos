{ lib, config, pkgs, ... }:

with lib;

let
in
{
  services.coredns.enable = true;

  services.coredns.config = ''
    . {
      bind eno1 127.0.0.1
      rewrite name suffix .o .tail09b98.ts.net
      forward . 1.1.1.1
    }
  '';

  networking.firewall.interfaces.eno1.allowedUDPPorts = [
    53
  ];
}
