{ lib, ... }:

with lib;

{
  services.traefik.dynamicConfigOptions = {
    http.services.jellyfin.loadBalancer.servers = [
      { url = "http://10.39.1.20:8096"; }
    ];
    http.routers.jellyfin = {
      rule = concatMapStringsSep " || " (r: "(${r})") [
        "Host(`jellyfin.pas.sh`)"
        "Host(`jellyfin.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)"
      ];
      service = "jellyfin@file";
      entryPoints = [ "web" ];
    };
  };
}
