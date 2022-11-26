{ lib, ... }:

with lib;

{
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
