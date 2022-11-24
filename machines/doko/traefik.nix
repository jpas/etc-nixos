{ lib, config, ... }:

with lib;

let
in
{
  services.traefik.enable = true;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.traefik.dynamicConfigOptions = mkMerge [
    {
      http.serversTransports.insecure-skip-verify.insecureSkipVerify = true;
    }

    (mkIf config.services.traefik.staticConfigOptions.api.dashboard {
      http.routers.dashboard = {
        rule = "Host(`traefik.o.pas.sh`) && ClientIP(`100.64.0.0/16`)";
        service = "api@internal";
        entryPoints = [ "web" ];
      };
    })

    {
      http.services.unifi.loadBalancer.servers = [
        { url  = "https://10.39.0.2:8443"; }
      ];
      http.routers.unifi = {
        rule = "Host(`unifi.o.pas.sh`) && ClientIP(`100.64.0.0/16`)";
        service = "unifi@file";
        entryPoints = [ "web" ];
      };
    }

    {
      http.services.jellyfin.loadBalancer.servers = [
        { url  = "http://10.39.1.20:8096"; }
      ];
      http.routers.jellyfin = {
        rule = "(Host(`jellyfin.o.pas.sh`) && ClientIP(`100.64.0.0/16`)) || Host(`jellyfin.pas.sh`)";
        service = "jellyfin@file";
        entryPoints = [ "web" ];
      };
    }
  ];

  services.traefik.staticConfigOptions = {
    api.dashboard = true;

    serversTransport.insecureSkipVerify = true;

    accessLog = {};

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

  age.secrets."traefik-tokens" = {
    file = ./traefik-tokens.age;
    owner = "traefik";
  };

  systemd.services."traefik" = {
    serviceConfig.EnvironmentFile = config.age.secrets."traefik-tokens".path;
  };
}
