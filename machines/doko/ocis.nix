{ lib, config, pkgs, ... }:

with lib;

let
  proxy-config = pkgs.writeText "proxy.yaml" ''
    role_assignment:
      driver: oidc
      oidc_role_mapper:
        role_claim: groups
        role_mapping:
          admin: ocis_admin
          guest: ocis_guest
          spaceadmin: ocis_space_admin
          user: ocis_user
  '';
in
{
  virtualisation.oci-containers.containers = {
    ocis = {
      image = "docker.io/owncloud/ocis:latest";

      ports = [ "127.0.0.2:9200:9200/tcp" ];

      environment = rec {
        OCIS_DOMAIN = "ocis.pas.sh";
        OCIS_INSECURE = "false";
        OCIS_LOG_COLOR = "false";
        OCIS_LOG_LEVEL = "info";
        OCIS_URL = "https://${OCIS_DOMAIN}";

        OCIS_ADMIN_USER_ID = "";

        OCIS_OIDC_ISSUER = "https://auth.pas.sh";

        PROXY_TLS = "false";
        PROXY_ENABLE_BASIC_AUTH = "false";

        PROXY_AUTOPROVISION_ACCOUNTS = "true";

        PROXY_OIDC_REWRITE_WELLKNOWN = "true";
        PROXY_OIDC_ACCESS_TOKEN_VERIFY_METHOD = "none";

        WEB_OIDC_CLIENT_ID = "ocis-web";
        WEB_OIDC_SCOPE = "openid profile groups email";

        GRAPH_ASSIGN_DEFAULT_USER_ROLE = "false";

      };

      entrypoint = "/bin/sh";
      cmd = [ "-c" "ocis init | true; ocis server" ];

      volumes = [
        "ocis-config:/etc/ocis"
        "${proxy-config}:/etc/ocis/proxy.yaml:ro"
        "ocis-data:/var/lib/ocis"
      ];
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.ocis = {
      loadBalancer.servers = [{ url = "http://127.0.0.2:9200"; }];
    };

    routers.ocis = {
      rule = "Host(`ocis.pas.sh`)";
      service = "ocis";
      entryPoints = [ "web" ];
    };
  };

  services.authelia.instances.main.settings.identity_providers.oidc.clients = [
    {
      description = "ownCloud Web";
      id = "ocis-web";
      public = true;
      consent_mode = "implicit";
      scopes = [
        "email"
        "groups"
        "openid"
        "profile"
      ];
      redirect_uris = [
        "https://ocis.pas.sh/"
        "https://ocis.pas.sh/oidc-callback.html"
        "https://ocis.pas.sh/oidc-silent-redirect.html"
      ];
    }
    {
      description = "ownCloud Desktop";
      id = "xdXOt13JKxym1B1QcEncf2XDkLAexMBFwiT9j6EfhhHFJhs2KM9jbjTmf8JBXE69";
      secret = "UBntmLjC2yYCeHwsyj73Uwo9TAaecAetRwMw0xYcvNL9yRdLSUi0hUAHfvCHFeFh";
      scopes = [
        "email"
        "groups"
        "openid"
        "profile"
        "offline_access"
      ];
      redirect_uris = [
        "http://127.0.0.1"
        "http://localhost"
      ];
    }
    {
      description = "ownCloud Android";
      id = "e4rAsNUSIUs0lF4nbv9FmCeUkTlV9GdgTLDH1b5uie7syb90SzEVrbN7HIpmWJeD";
      secret = "dInFYGV33xKzhbRmpqQltYNdfLdJIfJ9L5ISoKhNoT9qZftpdWSP71VrpGR9pmoD";
      scopes = [
        "email"
        "groups"
        "openid"
        "profile"
        "offline_access"
      ];
      redirect_uris = [
        "oc://android.owncloud.com"
      ];
    }
    {
      description = "ownCloud iOS";
      id = "mxd5OQDk6es5LzOzRvidJNfXLUZS2oN3oUFeXPP8LpPrhx3UroJFduGEYIBOxkY1";
      secret = "KFeFWWEZO9TkisIQzR3fo7hfiMXlOpaqP8CFuTbSHzV1TUuGECglPxpiVKJfOXIx";
      scopes = [
        "email"
        "groups"
        "openid"
        "profile"
        "offline_access"
      ];
      redirect_uris = [
        "oc://ios.owncloud.com"
        "oc.ios://ios.owncloud.com"
      ];
    }
  ];
}
