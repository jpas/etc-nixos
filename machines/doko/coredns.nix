{ lib, config, pkgs, ... }:

with lib;

let
in
{
  services.coredns.enable = true;

  services.coredns.config = ''
    . {
      whoami
    }
  '';
}
