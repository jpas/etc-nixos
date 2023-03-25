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
      #authentication_backend.file = {
      #  path = "/var/lib/authelia/users.yml";
      #};
      authentication_backend.ldap = {
        implementation = "custom";
        url = "ldap://127.0.0.1:3890";
        base_dn = "dc=pas,dc=sh";
        username_attribute = "uid";
        additional_users_dn = "ou=people";
        users_filter = "(&({username_attribute}={input})(objectclass=person))";
        additional_groups_dn = "ou=groups";
        groups_filter = "(member={dn})";
        group_name_attribute = "cn";
        mail_attribute = "mail";
        display_name_attribute = "uid";
        user = "uid=authelia,ou=people,dc=pas,dc=sh";
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
      identity_providers.oidc = {
        cors.allowed_origins_from_client_redirect_uris = true;
        cors.endpoints = [
          "authorization"
          "introspection"
          "revocation"
          "token"
          "userinfo"
        ];
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.auth = {
      loadBalancer.servers = [{ url = "http://${cfg.address}"; }];
    };

    routers.auth = {
      rule = "Host(`auth.pas.sh`)";
      service = "auth";
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
    AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = authelia-authentication-backend-password.path;
  };

  age.secrets = {
    authelia-identity-provider-oidc-hmac-secret = { owner = "authelia"; file = ./.authelia-identity-provider-oidc-hmac-secret.age; };
    authelia-identity-provider-oidc-issuer-private-key = { owner = "authelia"; file = ./.authelia-identity-provider-oidc-issuer-private-key.age; };
    authelia-jwt-secret = { owner = "authelia"; file = ./.authelia-jwt-secret.age; };
    authelia-notifier-smtp-password = { owner = "authelia"; file = ./.authelia-notifier-smtp-password.age; };
    authelia-storage-encryption-key = { owner = "authelia"; file = ./.authelia-storage-encryption-key.age; };
    authelia-authentication-backend-password = { owner = "authelia"; file = ./.authelia-authentication-backend-password.age; };
  };
}
