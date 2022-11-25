{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.authelia;

  frontend = "auth.pas.sh";
  backend = "${cfg.settings.server.host}:${cfg.settings.server.port}";
in
{
  imports = [ ./module.nix ];

  services.traefik.dynamicConfigOptions = {
    http.services.authelia.loadBalancer.servers = [
      { url = "http://${backend}"; }
    ];

    http.routers.authelia = {
      rule = "Host(`${host}`)";
      service = "authelia@file";
      entryPoints = [ "web" ];
    };

    http.routers.dashboard =
      mkIf config.services.traefik.staticConfigOptions.api.dashboard {
        middlewares = [ "authelia@file" ];
      }

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
        port = "9091";
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
    };
  };

  age.secrets."authelia-jwt-secret" = {
    file = ./jwt-secret.age;
    owner = "authelia";
  };

  age.secrets."authelia-storage-encryption-key" = {
    file = ./storage-encryption-key.age;
    owner = "authelia";
  };

  services.authelia = {
    jwtSecretFile = config.age.secrets."authelia-jwt-secret".path;
    storageEncryptionKeyFile = config.age.secrets."authelia-storage-encryption-key".path;
  };
}
