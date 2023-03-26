{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.authelia.instances.main;

  mkSecret = file: { inherit file; owner = cfg.user; };
in
{
  services.authelia.instances.main = {
    enable = true;
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
        path = "/var/lib/authelia-${cfg.name}/db.sqlite3";
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

    secrets = with config.age.secrets; {
      jwtSecretFile = authelia-jwt-secret.path;
      oidcIssuerPrivateKeyFile = authelia-identity-provider-oidc-issuer-private-key.path;
      oidcHmacSecretFile = authelia-identity-provider-oidc-hmac-secret.path;
      storageEncryptionKeyFile = authelia-storage-encryption-key.path;
    };

    environmentVariables = with config.age.secrets; {
      AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = authelia-notifier-smtp-password.path;
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = authelia-authentication-backend-password.path;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.auth = {
      loadBalancer.servers = [{ url = "http://127.0.0.1:9091"; }];
    };

    routers.auth = {
      rule = "Host(`auth.pas.sh`)";
      service = "auth";
      entryPoints = [ "web" ];
      middlewares = [ "authelia-delete-prompt" ];
    };

    middlewares.auth = {
      forwardAuth = {
        address = "http://127.0.0.1:9091/api/verify?rd=https%3A%2F%2Fauth.pas.sh%2F";
        trustForwardHeader = true;
        authResponseHeaders = [ "Remote-User" "Remote-Groups" "Remote-Name" "Remote-Email" ];
      };
    };

    middlewares.authelia-delete-prompt {
      modifyQuery = {
        type = "delete";
        paramName = "prompt";
      };
    };

    experimental.plugins.modifyQuery = {
      moduleName = "github.com/jpas/traefik-plugin-query-modification";
      version = "v0.1.0";
    };
  };

  age.secrets = {
    authelia-identity-provider-oidc-hmac-secret = mkSecret ./.authelia-identity-provider-oidc-hmac-secret.age;
    authelia-identity-provider-oidc-issuer-private-key = mkSecret ./.authelia-identity-provider-oidc-issuer-private-key.age;
    authelia-jwt-secret = mkSecret ./.authelia-jwt-secret.age;
    authelia-notifier-smtp-password = mkSecret ./.authelia-notifier-smtp-password.age;
    authelia-storage-encryption-key = mkSecret ./.authelia-storage-encryption-key.age;
    authelia-authentication-backend-password = mkSecret ./.authelia-authentication-backend-password.age;
  };
}
