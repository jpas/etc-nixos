{ lib, config, ... }:

with lib;

{
  services.traefik.dynamicConfigOptions.http = {
    services.jellyfin = {
      loadBalancer.servers = [{ url = "http://10.39.1.20:8096"; }];
    };

    routers.jellyfin = {
      rule = "Host(`jellyfin.pas.sh`)";
      service = "jellyfin";
      entryPoints = [ "web" ];
    };
  };

  services.authelia.settings.identity_providers.oidc.clients = [{
    id = "jellyfin";
    secret = "$file$" + config.age.secrets.authelia-identity-provider-oidc-clients-jellyfin-secret.path;
    authorization_policy = "one_factor";
    redirect_uris = [ "https://jellyfin.pas.sh/sso/OID/r/authelia" ];
  }];

  age.secrets = {
    authelia-identity-provider-oidc-clients-jellyfin-secret = { owner = "authelia"; file = ./.authelia-identity-provider-oidc-clients-jellyfin-secret.age; };
    #jellyfin-oidc-client-secret = { owner = "jellyfin"; file = ./.jellyfin-oidc-client-secret.age; };
  };
}
