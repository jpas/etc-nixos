{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.sourcehut;
  fqdn = "ht.pas.sh";
  secrets-root = "/etc/nixos/secrets/srht";
in
mkMerge [
  {
    services.sourcehut.enable = true;
    services.sourcehut = {
      meta.enable = true;
      git.enable = true;
      paste.enable = true;

      redis.enable = true;

      settings = {
        "sr.ht" = {
          environment = "production";
          global-domain = fqdn;
          origin = "https://${fqdn}";
          network-key = "${secrets-root}/network-key";
          service-key = "${secrets-root}/service-key";
        };

        webhooks = {
          private-key = "${secrets-root}/webhooks-private-key";
        };

        mail = {
          smtp-host = "smtp.fastmail.com";
          smtp-port = 587;
          smtp-encryption = "starttls";

          smtp-user = "<${secrets-root}/smtp-user";
          smtp-password = "<${secrets-root}/smtp-password";
          smtp-from = "<${secrets-root}/smtp-from";
        };
      };
    };
  }

  {
    services.sourcehut = {
      meta = {
        enable = true;
        redis.host = "unix:///run/redis-sourcehut-metasrht/redis.sock?db=0";
      };

      settings."meta.sr.ht" = {
        webhooks = "unix:///run/redis-sourcehut-metasrht/redis.sock?db=1";
      };

      # TODO: settings."meta.sr.ht::auth".auth-method = "unix-pam";
    };

    systemd.services.metasrht-webhooks.enable = false;
  }

  {
    services.sourcehut = {
      git = {
        enable = true;
        redis.host = "unix:///run/redis-sourcehut-gitsrht/redis.sock?db=0";
      };

      settings."git.sr.ht" = {
        oauth-client-id = "</etc/nixos/secrets/srht/git-oauth-client-id";
        oauth-client-secret = "/etc/nixos/secrets/srht/git-oauth-client-secret";
        webhooks = "unix:///run/redis-sourcehut-gitsrht/redis.sock?db=1";
      };
    };

    systemd.services.gitsrht-webhooks.enable = false;
  }

  {
    services.sourcehut = {
      paste = {
        enable = true;
      };

      settings."paste.sr.ht" = {
        oauth-client-id = "</etc/nixos/secrets/srht/paste-oauth-client-id";
        oauth-client-secret = "/etc/nixos/secrets/srht/paste-oauth-client-secret";
      };
    };
  }

  {
    services.sourcehut.postgresql.enable = true;
    services.postgresql = {
      enable = mkIf cfg.postgresql.enable true;
      package = pkgs.postgresql_11;
    };
  }

  {
    services.sourcehut.nginx.enable = true;
    services.sourcehut.nginx = {
      virtualHost.useACMEHost = fqdn;
    };

    security.acme.certs."${fqdn}" = {
      group = "nginx";
      extraDomainNames = [ "*.${fqdn}" ];
    };

    services.nginx = {
      enable = mkIf cfg.nginx.enable true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
    };
  }
]
