{ lib, ... }:

with lib;

{
  services.caddy.virtualHosts = {
    "unifi.o.pas.sh" = {
      useACMEHost = "o.pas.sh";
      extraConfig = ''
        reverse_proxy 10.39.0.2:8443
      '';
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.unifi = {
      loadBalancer.servers = [{ url = "https://10.39.0.2:8443"; }];
    };

    routers.unifi = {
      rule = "Host(`unifi.o.pas.sh`)";
      service = "unifi";
      entryPoints = [ "web" ];
      middlewares = [ "tailscale-ips" ];
    };
  };
}
