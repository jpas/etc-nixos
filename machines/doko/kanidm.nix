{ lib, config, pkgs, ... }:

with lib;

{
  services.kanidm.enableServer = true;
  services.kanidm.serverSettings = {
    domain = "https://idm.pas.sh";
    origin = "pas.sh";
    bindaddress = "127.0.0.1:8443";
    ldapbindaddress = "0.0.0.0:636";

    tls_chain = "${config.security.acme.certs."idm.pas.sh".directory}/fullchain.pem";
    tls_key = "${config.security.acme.certs."idm.pas.sh".directory}/key.pem";
  };

  services.traefik.dynamicConfigOptions.http = {
    services.kanidm = {
      loadBalancer.servers = [{ url = "http://127.0.0.1:8443"; }];
    };

    routers.kanidm = {
      rule = "Host(`idm.pas.sh`)";
      service = "kanidm";
      entryPoints = [ "web" ];
    };
  };

  users.users.kanidm.extraGroups = [ "acme" ];

  security.acme.certs."idm.pas.sh" = { };
}
