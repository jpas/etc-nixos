{ lib, config, ... }:

with lib;

let
in
{
  services.traefik.enable = true;

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

    entryPoints.web-redirect = {
      address = ":80";
      http.redirections.entrypoint = {
        to = "web";
        scheme = "https";
      };
    };

    certificateResolvers.acme ={
      email = "acme@pas.sh";
      storage = "acme.json";
      dnsChallenge.provider = "cloudflare";
    };
  };

  age.secrets."traefik-tokens" = {
    file = ./traefik-tokens.age;
    owner = "traefik";
  };

  systemd.services."traefik".serviceConfig = {
    EnvironmentFile = config.age.secrets."traefik-tokens".path;
  };
}
