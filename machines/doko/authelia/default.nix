{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.authelia;

  frontend = "auth.pas.sh";
  backend = "${cfg.settings.server.host}:${toString cfg.settings.server.port}";
in
{
  imports = [ ./module.nix ];

  services.traefik.dynamicConfigOptions = {
    http.services.authelia.loadBalancer.servers = [
      { url = "http://${backend}"; }
    ];

    http.routers.authelia = {
      rule = "Host(`${frontend}`)";
      service = "authelia@file";
      entryPoints = [ "web" ];
    };

    http.routers.dashboard.middlewares =
      mkIf config.services.traefik.staticConfigOptions.api.dashboard
        [ "authelia@file" ];

    http.middlewares.authelia.forwardAuth =  {
      address = "http://${backend}/api/verify?rd=https%3A%2F%2F${frontend}%2F";
      trustForwardHeader = true;
      authResponseHeaders = [ "Remote-User" "Remote-Groups" "Remote-Name" "Remote-Email" ];
    };

    http.middlewares.authelia-basic.forwardAuth = {
      address = "http://${backend}/api/verify?auth=basic";
      trustForwardHeader = true;
      authResponseHeaders = [ "Remote-User" "Remote-Groups" "Remote-Name" "Remote-Email" ];
    };
  };

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
        domain = "${frontend}";
      };
      authentication_backend.file = {
        path = "/var/lib/authelia/users.yml";
        watch = true;
      };
      storage.local = {
        path = "/var/lib/authelia/db.sqlite3";
      };
      access_control = {
        default_policy = "one_factor";
      };
      notifier.smtp = rec {
        host = "smtp.fastmail.com";
        port = 587;
        username = "jarrod@jarrodpas.com";
        sender = "no-reply@auth.pas.sh";
        startup_check_address = sender;
        disable_html_emails = true;
      };
    };
  };

  services.authelia.jwtSecretFile = config.age.secrets."authelia-jwt-secret".path;
  age.secrets."authelia-jwt-secret" = {
    file = ./jwt-secret.age;
    owner = "authelia";
  };

  services.authelia.storageEncryptionKeyFile = config.age.secrets."authelia-storage-encryption-key".path;
  age.secrets."authelia-storage-encryption-key" = {
    file = ./storage-encryption-key.age;
    owner = "authelia";
  };

  systemd.services.authelia.environment = {
    AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.age.secrets."authelia-notifier-smtp-password".path;
  };
  age.secrets."authelia-notifier-smtp-password" = {
    file = ./notifier-smtp-password.age;
    owner = "authelia";
  };
}
