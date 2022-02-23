{ lib
, config
, ...
}:

with lib;

let
  cfg = config.services.sourcehut;
  fqdn = config.settings."sr.ht".global-domain;
in
{
  services.sourcehut.enable = true;
  services.sourcehut.settings."sr.ht".global-domain = "ht.pas.sh";

  services.sourcehut = {
    meta.enable = true;
    git.enable = true;

    settings = {
      "sr.ht" = {
        environment = "production";
        origin = "https://${fqdn}";
        network-key = "/etc/nixos/secrets/srht/network-key";
        service-key = "/etc/nixos/secrets/srht/service-key";
      };

      webhooks = {
        private-key = "/etc/nixos/secrets/srht/webhooks-private-key";
      };
    };

  services.sourcehut.meta.enable = true;
  services.sourcehut = {
    meta = {
      redis.host = "unix:///run/redis-sourcehut-metasrht/redis.sock?db=0";
    };

    settings."meta.sr.ht" = {
      webhooks = "unix:///run/redis-sourcehut-metasrht/redis.sock?db=1";
    };
  };

  services.sourcehut.git.enable = true;
  services.sourcehut = {
    git = {
      redis.host = "unix:///run/redis-sourcehut-gitsrht/redis.sock?db=0";
    };

    settings."git.sr.ht" = {
      oauth-client-id = "9c76febb007a0eb4";
      oauth-client-secret = "/etc/nixos/secrets/srht/git-oauth-secret";
      webhooks = "unix:///run/redis-sourcehut-gitsrht/redis.sock?db=1";
    };
  };

  services.sourcehut.redis.enable = true;

  services.sourcehut.postgresql.enable = true;
  services.postgresql = {
    enable = mkIf cfg.postgresql.enable true;
    package = pkgs.postgresql_11;
  };

  security.acme.certs."${fqdn}".extraDomainNames = [ "*.${fqdn}" ];

  services.sourcehut.nginx.enable = true;
  services.sourcehut.nginx = {
    virtualHost.useACMEHost = fqdn;
  };

  services.nginx = {
    enable = mkIf cfg.nginx.enable true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
}
