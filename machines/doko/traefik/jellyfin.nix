{ lib, ... }:

with lib;

{
  services.traefik.dynamicConfigOptions = {
    http.services.jellyfin.loadBalancer.servers = [
      { url = "http://10.39.1.20:8096"; }
    ];
    http.routers.jellyfin = {
      rule = "Host(`jellyfin.pas.sh`)";
      service = "jellyfin";
      entryPoints = [ "web" ];
    };
  };
}
