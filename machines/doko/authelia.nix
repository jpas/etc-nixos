{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.authelia;
in
{
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

  services.traefik.dynamicConfigOptions.http = {
    services.auth = {
      loadBalancer.servers = [{ url = "http://${cfg.address}"; }];
    };

    routers.auth = {
      rule = "Host(`auth.pas.sh`)";
      service = "auth@file";
      entryPoints = [ "web" ];
    };

    middlewares.auth = {
      forwardAuth = {
        address = "http://${cfg.address}/api/verify?rd=https%3A%2F%2Fauth.pas.sh%2F";
        trustForwardHeader = true;
        authResponseHeaders = [ "Remote-User" "Remote-Groups" "Remote-Name" "Remote-Email" ];
      };
    };
  };

  systemd.services.authelia.environment = with config.age.secrets; {
    AUTHELIA_IDENTITY_PROVIDERS_OIDC_HMAC_SECRET_FILE = authelia-identity-provider-oidc-hmac-secret.path;
    AUTHELIA_IDENTITY_PROVIDERS_OIDC_ISSUER_PRIVATE_KEY_FILE = authelia-identity-provider-oidc-issuer-private-key.path;
    AUTHELIA_JWT_SECRET_FILE = authelia-jwt-secret.path;
    AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = authelia-notifier-smtp-password.path;
    AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = authelia-storage-encryption-key.path;
  };

  age.secrets = {
    authelia-identity-provider-oidc-hmac-secret = { owner = "authelia"; file = ./.authelia-identity-provider-oidc-hmac-secret.age; };
    authelia-identity-provider-oidc-issuer-private-key = { owner = "authelia"; file = ./.authelia-identity-provider-oidc-issuer-private-key.age; };
    authelia-jwt-secret = { owner = "authelia"; file = ./.authelia-jwt-secret.age; };
    authelia-notifier-smtp-password = { owner = "authelia"; file = ./.authelia-notifier-smtp-password.age; };
    authelia-storage-encryption-key = { owner = "authelia"; file = ./.authelia-storage-encryption-key.age; };
  };
}
