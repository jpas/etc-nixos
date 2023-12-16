{ lib, config, pkgs, ... }:

with lib;

let
  enable = true;
  cfg = config.services.authelia.instances.main;

  optionalGetAttrByPath = default: path: set:
    if   hasAttrByPath path set
    then getAttrByPath path set
    else default;

  haveOIDC =
    let
      path = [ "identity_providers" "oidc" "clients" ];
      clients = optionalGetAttrByPath [ ] path cfg.settings;
    in
      (length clients) > 0;

  mkSecret = file: { inherit file; owner = cfg.user; };
in
{
  services.authelia.instances.main = mkMerge [
    {
      inherit enable;
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
          clients = [
            {
              description = "dummy";
              id = "dummy";
              public = true;
              consent_mode = "implicit";
              scopes = [ ];
              redirect_uris = [ "invalid://" ];
            }
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

    }
  ];

  systemd.services."authelia-main" = {
    after = [ "lldap.service" ];
    bindsTo = [ "lldap.service" ];
  };

  services.caddy.extraConfig = mkBefore ''
    (forward_login) {
      forward_auth 127.0.0.1:9091 {
        uri /api/verify?rd=https//auth.pas.sh
        copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
      }
    }
  '';

  services.caddy.virtualHosts = {
    "auth.pas.sh" = {
      useACMEHost = "pas.sh";
      extraConfig = ''
        uri /api/oidc/authorization replace &prompt=select_account%20consent ""
        reverse_proxy 127.0.0.1:9091
      '';
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
