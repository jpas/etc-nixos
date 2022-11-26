{ lib, config, ... }:

with (lib.extend (import ./lib.nix));

let
  cfg = config.services.traefik;
in
{
  options.services.traefik = {
    dashboard = mkEnableOption "traefik dashboard";
  };

  config = mkIf cfg.dashboard {
    services.traefik.staticConfigOptions = {
      api.dashboard = mkForce true;
    };

    services.traefik.dynamicConfigOptions = {
      http.routers.dashboard = {
        rule = "Host(`traefik.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
        service = "api@internal";
        entryPoints = [ "web" ];
        middlewares = [ "auth" ];
      };
    };

    services.authelia.settings.access_control.rules = [
      { domain = "traefik.o.pas.sh"; subject = [ "group:wheel" ]; }
    ];
  };
}
