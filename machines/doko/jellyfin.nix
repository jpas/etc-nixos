{ lib, config, ... }:

with lib;

{
  services.jellyfin.enable = true;

  services.traefik.dynamicConfigOptions.http = {
    services.jellyfin = {
      loadBalancer.servers = [{ url = "http://127.0.0.1:8096"; }];
    };

    routers.jellyfin = {
      rule = "Host(`jellyfin.pas.sh`)";
      service = "jellyfin";
      entryPoints = [ "web" ];
    };
  };
}
