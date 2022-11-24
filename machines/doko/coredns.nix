{ lib, config, pkgs, ... }:

with lib;

let
in
{
  services.coredns.enable = false;

  services.resolved.extraConfig = mkIf config.services.coredns.enable ''
    [Resolve]
    DNS=127.0.0.1
    DNSStubListener=no
  '';

  services.coredns.config = ''
    . {
      forward . 1.1.1.1 1.0.0.1
      cache
    }
  '';
}
