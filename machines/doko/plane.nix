{ lib, config, ... }:

with lib;

let
  service = "plane";
  backend = "10.39.1.20:3000";
in
{
  services.caddy.virtualHosts = {
    "${service}.pas.sh" = {
      useACMEHost = "pas.sh";
      extraConfig = ''
        reverse_proxy ${backend}
      '';
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.${service} = {
      loadBalancer.servers = [{ url = "http://${backend}"; }];
    };

    routers.${service} = {
      inherit service;
      rule = "Host(`${service}.pas.sh`)";
      entryPoints = [ "web" ];
    };
  };
}

