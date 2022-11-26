{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.authelia;

  backend = "${cfg.settings.server.host}:${toString cfg.settings.server.port}";
in
{
  imports = [ ./module.nix ./secrets ];

  services.authelia.enable = true;
  services.authelia = {
    settings = {
      theme = "dark";
      log = {
        level = "info";
        format = "text";
      };
      server = {
        host = "127.0.0.1";
        port = 9091;
      };
      session = {
        name = "session";
        domain = "pas.sh";
      };
      authentication_backend.file = {
        path = "/var/lib/authelia/users.yml";
      };
      storage.local = {
        path = "/var/lib/authelia/db.sqlite3";
      };
      access_control = {
        default_policy = "deny";
      };
      notifier.smtp = rec {
        host = "smtp.fastmail.com";
        port = 587;
        username = "jarrod@jarrodpas.com";
        sender = "noreply@auth.pas.sh";
        startup_check_address = sender;
        disable_html_emails = true;
      };
    };
  };

  systemd.tmpfiles.rules = [ "d /var/lib/authelia 0700 authelia authelia - -" ];

  users.users.authelia = {
    group = "authelia";
    home = "/var/lib/authelia";
    createHome = true;
    isSystemUser = true;
  };

  systemd.services.authelia = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      AmbientCapabilities = "cap_net_bind_service";
      CapabilityBoundingSet = "cap_net_bind_service";
      NoNewPrivileges = true;
      LimitNPROC = 64;
      LimitNOFILE = 1048576;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHome = true;
      ProtectSystem = "full";
      ReadWriteDirectories = "/var/lib/authelia";
    };
  };

  services.authelia = {
    jwtSecretFile = config.age.secrets."authelia-jwt-secret".path;
    storageEncryptionKeyFile = config.age.secrets."authelia-storage-encryption-key".path;
    oidcHmacSecretFile = config.age.secrets."authelia-oidc-hmac-secret".path;
    oidcIssuerPrivateKeyFile = config.age.secrets."authelia-oidc-issuer-private-key".path;
  };

  systemd.services.authelia.environment = {
    AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.age.secrets."authelia-notifier-smtp-password".path;
  };

  services.traefik.dynamicConfigOptions = {
    http.services.auth.loadBalancer.servers = [
      { url = "http://${backend}"; }
    ];

    http.routers.auth = {
      rule = "Host(`auth.pas.sh`)";
      service = "auth@file";
      entryPoints = [ "web" ];
    };

    http.routers.dashboard.middlewares =
      mkIf config.services.traefik.staticConfigOptions.api.dashboard
        [ "auth@file" ];

    http.middlewares.auth.forwardAuth =  {
      address = "http://${backend}/api/verify?rd=https%3A%2F%2Fauth.pas.sh%2F";
      trustForwardHeader = true;
      authResponseHeaders = [ "Remote-User" "Remote-Groups" "Remote-Name" "Remote-Email" ];
    };
  };
}
