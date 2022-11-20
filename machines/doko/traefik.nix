{ lib, config, ... }:

with lib;

let
in
{
  services.traefik.enable = true;

  services.traefik.dynamicConfigOptions = mkMerge [
    (mkIf config.services.traefik.staticConfigOptions.api.dashboard {
      http.routers.dashboard = {
        entryPoints = [ "web" ];
        rule = "Host(`traefik.o.pas.sh`) && ClientIP(`100.0.0.0/8`)";
        service = "api@internal";
      };
    })

    {
      http.services.jellyfin.loadBalancer.servers = [
        { url  = "http://10.39.0.20:8096"; }
      ];
      http.routers.jellyfin = {
        entryPoints = [ "web" ];
        rule = "(Host(`jellyfin.o.pas.sh`) && ClientIP(`100.0.0.0/8`)) || Host(`jellyfin.pas.sh`)";
        service = "jellyfin@file";
      };
    }
  ];

  services.traefik.staticConfigOptions = {
    api.dashboard = true;

    entryPoints.web = {
      address = ":443";
      http.tls = {
        certResolver = "acme";
        domains = [
          {
            main = "pas.sh";
            sans = [ "*.pas.sh" "*.o.pas.sh" ];
          }
          {
            main = "jpas.xyz";
            sans = [ "*.jpas.xyz" ];
          }
          {
            main = "jarrodpas.com";
            sans = [ "*.jarrodpas.com" ];
          }
        ];
      };
    };

    entryPoints.web-insecure = {
      address = ":80";
      http.redirections.entrypoint = {
        to = "web";
        scheme = "https";
      };
    };


    certificatesResolvers.acme.acme = {
      email = "acme@pas.sh";
      storage = "/var/lib/traefik/acme.json";
      dnsChallenge.provider = "cloudflare";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  age.secrets."traefik-tokens" = {
    file = ./traefik-tokens.age;
    owner = "traefik";
  };

  systemd.services."traefik" = {
    serviceConfig.EnvironmentFile = config.age.secrets."traefik-tokens".path;
  };
}
