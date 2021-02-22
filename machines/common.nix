{ lib, ... }:

with lib;

let
  hole = {
    kado = "100.116.4.62";
    kuro = "100.65.152.104";
  };

  mkHosts = hosts: domain:
    mapAttrs' (host: ip: { name = ip; value = [ (host + domain) ]; }) hosts;

in {
  networking.hosts = mkHosts hole ".hole";
}
