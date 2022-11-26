{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.traefik;
in
{
  imports = [
    ./dashboard.nix
    ./jellyfin.nix
    ./sonarr.nix
    ./radarr.nix
    ./unifi.nix
  ];

  services.traefik.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.traefik.staticConfigFile = "/var/lib/traefik/config.yml";

  systemd.services.traefik.preStart = ''
    ${pkgs.jq}/bin/jq --slurp '.[0] * .[1]' \
      ${pkgs.writeText "config.json" (builtins.toJSON cfg.staticConfigOptions)} \
      ${config.age.secrets."traefik-config.json".path} \
      > ${cfg.staticConfigFile}
  '';

  services.traefik.staticConfigOptions = {
    providers.file.filename =
      pkgs.writeText "config.yml" (builtins.toJSON cfg.dynamicConfigOptions);

    api.dashboard = true;

    serversTransport.insecureSkipVerify = true;

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

  services.traefik.dynamicConfigOptions = {
    http.serversTransports = {
      insecure-skip-verify.insecureSkipVerify = true;
    };
  };

  age.secrets."traefik-env" = {
    file = ./env.age;
    owner = "traefik";
  };

  age.secrets."traefik-config.json" = {
    file = ./config.json.age;
    owner = "traefik";
  };

  systemd.services."traefik" = {
    serviceConfig.EnvironmentFile = config.age.secrets."traefik-env".path;
  };
}
