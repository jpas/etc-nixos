{ lib, config, pkgs, ... }:

let
  cfg = config.services.influxdb2;
in
{
  services.influxdb2.enable = true;
  services.influxdb2.settings = {
    http-bind-address = "127.0.0.1:8086";
  };

  services.traefik.dynamicConfigOptions = {
    http.services.influx.loadBalancer.servers = [
      { url = "http://${cfg.settings.http-bind-address}"; }
    ];
    http.routers.influx = {
      rule = "(Host(`influx.o.pas.sh`) && ClientIP(`100.64.0.0/16`))";
      service = "influx@file";
      entryPoints = [ "web" ];
    };
  };
}
