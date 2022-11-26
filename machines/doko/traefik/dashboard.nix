{ lib, config, ... }:

with lib;

let
  cfg = config.services.traefik;
in
{
  services.traefik.dynamicConfigOptions = {
    http.routers.dashboard = {
      rule = "Host(`traefik.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
      service = "api@internal";
      entryPoints = [ "web" ];
      middlewares = [ "auth" ];
    };
  };

  services.authelia.settings.access_control.rules = [
    { domain = "traefik.o.pas.sh"; policy = "one_factor"; subject = [ "group:wheel" ]; }
  ];
}
