{ lib
, ...
}:

with lib;

let
  hole = {
    kado = "100.65.152.104";
    kuro = "100.116.4.62";
    shiro = "100.69.65.63";
  };

  mkHosts = hosts: domain:
    mapAttrs'
      (host: ip: {
        name = ip;
        value = [ (host + domain) ];
      })
      hosts;
in
{
  networking.hosts = mkHosts hole ".o";

  services.tailscale.enable = true;
}