{ lib, config, ... }:

with lib;

let
in
{
  services.traefik.enable = true;

  services.traefik.dynamicConfigOptions = {
    http.routers.dashboard = {
      rule = "Host(`traefik.pas.sh`) && PathPrefix(`/api`, `/dashboard`)";
      service = "api@internal";
    };
  };

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
    preStart = ''
      [[ -e ${
    '';
    serviceConfig.EnvironmentFile = config.age.secrets."traefik-tokens".path;
  };
}
