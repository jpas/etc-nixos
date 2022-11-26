{ lib, ... }:

with lib;

{
  services.traefik.dynamicConfigOptions = {
    http.services.radarr.loadBalancer.servers = [
      { url = "http://10.39.1.20:7878"; }
    ];
    http.routers.radarr = {
      rule = "Host(`radarr.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
      service = "radarr";
      entryPoints = [ "web" ];
      middlewares = [ "auth" ];
    };
  };

  services.authelia.settings.access_control.rules = [
    { domain = "radarr.o.pas.sh"; policy = "one_factor"; subject = [ "group:wheel" ]; }
  ];
}
