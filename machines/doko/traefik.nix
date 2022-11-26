{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.traefik;
in
{
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
    accessLog = { };

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

  services.traefik.dynamicConfigOptions.http = {
    serversTransports = {
      insecure-skip-verify.insecureSkipVerify = true;
    };

    routers.dashboard = {
      rule = "Host(`traefik.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
      service = "api@internal";
      entryPoints = [ "web" ];
      middlewares = [ "auth" ];
    };
  };

  services.authelia.settings.access_control.rules = [
    { domain = "traefik.o.pas.sh"; subject = [ "group:wheel" ]; policy = "one_factor"; }
  ];

  systemd.services.traefik = {
    serviceConfig.EnvironmentFile = config.age.secrets."traefik-env".path;
  };

  age.secrets = {
    "traefik-env" = { owner = "traefik"; file = ./.traefik-env.age; };
    "traefik-config.json" = { owner = "traefik"; file = ./.traefik-config.json.age; };
  };
}
