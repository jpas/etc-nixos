{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.influxdb2;
in
{
  services.influxdb2.enable = false;

  services.traefik.dynamicConfigOptions.http = mkIf cfg.enable {
    services.influx = {
      loadBalancer.servers = [{ url = "http://localhost:8086"; }];
    };
    routers.influx = {
      rule = "Host(`influx.o.pas.sh`)";
      service = "influx";
      entryPoints = [ "web" ];
      middlewares = [ "tailscale-ips" ];
    };
  };
}
