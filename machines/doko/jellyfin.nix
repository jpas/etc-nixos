{ lib, ... }:

{
  services.traefik.dynamicConfigOptions = {
    http.services.jellyfin.loadBalancer.servers = [
      { url = "http://10.39.1.20:8096"; }
    ];
    http.routers.jellyfin = {
      rule = "(Host(`jellyfin.o.pas.sh`) && ClientIP(`100.64.0.0/16`)) || Host(`jellyfin.pas.sh`)";
      service = "jellyfin@file";
      entryPoints = [ "web" ];
    };
  };
}
