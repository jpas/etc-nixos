{ lib, config, ... }:

with lib;

{
  services.jellyfin.enable = true;
  systemd.services.jellyfin = {
    serviceConfig = {
      RequiresMountsFor = "/aleph";
    };
  };

  services.caddy.virtualHosts = {
    "jellyfin.pas.sh" = {
      useACMEHost = "pas.sh";
      extraConfig = ''
        reverse_proxy 127.0.0.1:8096
      '';
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.jellyfin = {
      loadBalancer.servers = [{ url = "http://127.0.0.1:8096"; }];
    };

    routers.jellyfin = {
      rule = "Host(`jellyfin.pas.sh`)";
      service = "jellyfin";
      entryPoints = [ "web" ];
    };
  };
}
