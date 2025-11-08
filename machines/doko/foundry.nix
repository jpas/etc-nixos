{ lib, config, ... }:

with lib;

let
  service = "foundry";
  backend = "10.39.0.52:30000";
in
{
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

