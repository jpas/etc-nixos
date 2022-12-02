{ lib, config, ... }:

with lib;

{
  services.jellyfin.enable = false;

  services.traefik.dynamicConfigOptions.http = {
    services.jellyfin = {
      loadBalancer.servers = [{
        url =
          if config.services.jellyfin.enable
          then "http://127.0.0.1:8096"
          else "http://10.39.1.20:8096";
      }];
    };

    routers.jellyfin = {
      rule = "Host(`jellyfin.pas.sh`)";
      service = "jellyfin";
      entryPoints = [ "web" ];
      #middlewares = [ "jellyfin-auth" ];
    };

    #middlewares.jellyfin-auth = {
    #  redirectRegex = {
    #    regex = "^https://jellyfin.pas.sh/$";
    #    replacement = "https://jellyfin.pas.sh/sso/OID/p/auth";
    #  };
    #};
  };

  services.authelia.settings.identity_providers.oidc.clients = [{
    id = "jellyfin";
    secret = "$file$" + config.age.secrets.authelia-identity-provider-oidc-clients-jellyfin-secret.path;
    authorization_policy = "one_factor";
    redirect_uris = [ "https://jellyfin.pas.sh/sso/OID/r/auth" ];
  }];

  age.secrets = {
    authelia-identity-provider-oidc-clients-jellyfin-secret = { owner = "authelia"; file = ./.authelia-identity-provider-oidc-clients-jellyfin-secret.age; };
    #jellyfin-oidc-client-secret = { owner = "jellyfin"; file = ./.jellyfin-oidc-client-secret.age; };
  };
}
