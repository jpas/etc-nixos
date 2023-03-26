{ lib, ... }:

with lib;

{
  services.traefik.dynamicConfigOptions.http = {
    services.radarr = {
      loadBalancer.servers = [{ url = "http://10.39.1.20:7878"; }];
    };

    routers.radarr = {
      rule = "Host(`radarr.o.pas.sh`)";
      service = "radarr";
      entryPoints = [ "web" ];
      middlewares = [ "tailscale-ips" "auth" ];
    };
  };

  services.authelia.instances.main.settings.access_control.rules = [
    { domain = "radarr.o.pas.sh"; subject = [ "group:media_admin" ]; policy = "one_factor"; }
  ];
}
