{ lib, ... }:

with lib;

let
  hole = {
    kado = "100.65.152.104";
    kuro = "100.116.4.62";
  };

  mkHosts = hosts: domain:
    mapAttrs' (host: ip: {
      name = ip;
      value = [ (host + domain) ];
    }) hosts;

in {
  networking.hosts = mkHosts hole ".o";

  # We do not need rpcbind for nfs4
  systemd.services.rpcbind.enable = false;
}
