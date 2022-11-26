{ lib, ... }:

with lib;

{
  services.traefik.dynamicConfigOptions = {
    http.services.sonarr.loadBalancer.servers = [
      { url = "http://10.39.1.20:8989"; }
    ];
    http.routers.sonarr = {
      rule = "Host(`sonarr.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
      service = "sonarr";
      entryPoints = [ "web" ];
      middlewares = [ "auth" ];
    };
  };

  services.authelia.settings.access_control.rules = [
    { domain = "sonarr.o.pas.sh"; policy = "one_factor"; subject = [ "group:wheel" ]; }
  ];
}
