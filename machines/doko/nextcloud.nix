{ lib, ... }:

with lib;

let
  domain = "nextcloud";
in
{
  services.traefik.dynamicConfigOptions.http = {
    services.${domain} = {
      loadBalancer.servers = [{ url = "http://10.39.1.20:9190"; }];
    };

    routers.${domain} = {
      rule = "Host(`${domain}.pas.sh`)";
      service = domain;
      entryPoints = [ "web" ];
      middlewares = [ "auth" ];
    };
  };

  services.authelia.instances.main.settings.access_control.rules = [
    { domain = "${domain}.pas.sh"; subject = [ "group:media_admin" ]; policy = "one_factor"; }
  ];
}
