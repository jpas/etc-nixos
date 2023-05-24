{ lib, ... }:

with lib;

{
  services.caddy.virtualHosts = {
    "sonarr.o.pas.sh" = {
      useACMEHost = "o.pas.sh";
      extraConfig = ''
        import forward_login
        reverse_proxy 10.39.1.20:8989
      '';
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.sonarr = {
      loadBalancer.servers = [{ url = "http://10.39.1.20:8989"; }];
    };

    routers.sonarr = {
      rule = "Host(`sonarr.o.pas.sh`)";
      service = "sonarr";
      entryPoints = [ "web" ];
      middlewares = [ "tailscale-ips" "auth" ];
    };
  };

  services.authelia.instances.main.settings.access_control.rules = [
    { domain = "sonarr.o.pas.sh"; subject = [ "group:media_admin" ]; policy = "one_factor"; }
  ];
}
