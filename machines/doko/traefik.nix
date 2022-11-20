{ lib, config, ... }:

with lib;

let
in
{
  services.traefik.enable = true;

  services.traefik.dynamicConfigOptions = foldl recursiveUpdate [
    {
      http.routers.dashboard = {
        rule = "ClientIP(`100.0.0.0/8`) && Host(`traefik.o.pas.sh`)";
        service = "api@internal";
      };
    }

    {
      http.services.jellyfin = {
        loadBalancer.servers = [ { url  = "http://10.39.0.20:8096"; } ];
      };
      http.routers.jellyfin = {
        rule = "ClientIP(`100.0.0.0/8`) && Host(`jellyfin.o.pas.sh`)";
        service = "jellyfin@file";
      };
    }
  ];

  services.traefik.staticConfigOptions = {
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

    api = {
      dashboard = true;
      insecure = true;
    };

    certificatesResolvers.acme.acme = {
      email = "acme@pas.sh";
      storage = "/var/lib/traefik/acme.json";
      dnsChallenge.provider = "cloudflare";
    };
  };

  networking.firewall.interfaces.eno1.allowedTCPPorts = [
    8080
  ];

  age.secrets."traefik-tokens" = {
    file = ./traefik-tokens.age;
    owner = "traefik";
  };

  systemd.services."traefik" = {
    serviceConfig.EnvironmentFile = config.age.secrets."traefik-tokens".path;
  };
}
