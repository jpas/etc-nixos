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
      email = config.security.acme.defaults.email;
      keyType = toUpper config.security.acme.defaults.keyType;
      dnsChallenge.provider = config.security.acme.defaults.dnsProvider;
      storage = "/var/lib/traefik/acme.json";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    serversTransports = {
      insecure-skip-verify.insecureSkipVerify = true;
    };

    routers.dashboard = {
      rule = "Host(`traefik.o.pas.sh`) ";
      service = "api@internal";
      entryPoints = [ "web" ];
      middlewares = [ "tailscale-ips" "auth" ];
    };

    middlewares.tailscale-ips = {
      ipWhiteList.sourceRange = [ "100.64.0.0/10" "fd7a:115c:a1e0:ab12::/64" ];
    };
  };

  services.authelia.instances.main.settings.access_control.rules = [
    { domain = "traefik.o.pas.sh"; subject = [ "group:admin" ]; policy = "one_factor"; }
  ];

  systemd.services.traefik = {
    serviceConfig.EnvironmentFile = config.security.acme.defaults.credentialsFile;
  };

  users.users.traefik.extraGroups = [ "acme" ];

  age.secrets = {
    "traefik-config.json" = { owner = "traefik"; file = ./.traefik-config.json.age; };
  };
}
