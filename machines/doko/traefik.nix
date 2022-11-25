{ lib, config, ... }:

with lib;

let
  cfg = config.services.traefik;

  staticConfigFile = pkgs.writeText "config.json" (toJSON cfg.staticConfigOptions);
in
{
  services.traefik.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.traefik.staticConfigFile = "/var/lib/traefik/config.json";

  services.traefik.staticConfigOptions = {
    providers.file.filename =
      pkgs.writeText "config.json" (toJSON cfg.dynamicConfigOptions);

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

    metrics.influxDB2.address = "http://localhost:8086";

    certificatesResolvers.acme.acme = {
      email = "acme@pas.sh";
      storage = "/var/lib/traefik/acme.json";
      dnsChallenge.provider = "cloudflare";
    };
  };

  age.secrets."traefik-config.json" = {
    file = ./traefik-config.json.age;
    owner = "traefik";
  };

  systemd.services.traefik.preStart = ''
    ${pkgs.jq}/bin/jq '.[0]*.[1]' \
      ${pkgs.writeText "config.json" (toJSON cfg.staticConfigOptions)} \
      ${config.age.secrets."traefik-config.json"} \
      > ${cfg.staticConfigFile}
  '';

  services.traefik.dynamicConfigOptions = mkMerge [
    {
      http.serversTransports.insecure-skip-verify.insecureSkipVerify = true;
    }

    (mkIf config.services.traefik.staticConfigOptions.api.dashboard {
      http.routers.dashboard = {
        rule = "Host(`traefik.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
        service = "api@internal";
        entryPoints = [ "web" ];
      };
    })

    {
      http.services.unifi.loadBalancer.servers = [
        { url = "https://10.39.0.2:8443"; }
      ];
      http.routers.unifi = {
        rule = "Host(`unifi.o.pas.sh`) && ClientIP(`100.64.0.0/10`, `fd7a:115c:a1e0:ab12::/64`)";
        service = "unifi@file";
        entryPoints = [ "web" ];
      };
    }
  ];

  age.secrets."traefik-env" = {
    file = ./traefik-env.age;
    owner = "traefik";
  };

  systemd.services."traefik" = {
    serviceConfig.EnvironmentFile = config.age.secrets."traefik-env".path;
  };
}
