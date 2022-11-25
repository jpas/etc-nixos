{ lib, config, pkgs, ... }:

let
  cfg = config.services.influxdb2;
in
{
  services.influxdb2.enable = false;

  services.traefik.dynamicConfigOptions = {
    http.services.influx.loadBalancer.servers = [
      { url = "http://localhost:8086"; }
    ];
    http.routers.influx = {
      rule = "Host(`influx.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
      service = "influx@file";
      entryPoints = [ "web" ];
    };
  };
}
