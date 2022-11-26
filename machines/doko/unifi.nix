{ lib, ... }:

with lib;

{
  services.traefik.dynamicConfigOptions.http = {
    services.unifi = {
      loadBalancer.servers = [{ url = "https://10.39.0.2:8443"; }];
    };

    routers.unifi = {
      rule = "Host(`unifi.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
      service = "unifi";
      entryPoints = [ "web" ];
    };
  };
}
