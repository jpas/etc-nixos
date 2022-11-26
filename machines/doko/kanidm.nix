{ lib, config, pkgs, ... }:

with lib;

{
  services.kanidm.enableServer = true;
  services.kanidm.serverSettings = {
    origin = "https://idm.pas.sh";
    domain = "idm.pas.sh";
    bindaddress = "127.0.0.1:8443";
    ldapbindaddress = "0.0.0.0:636";

    tls_chain = "${config.security.acme.certs."idm.pas.sh".directory}/fullchain.pem";
    tls_key = "${config.security.acme.certs."idm.pas.sh".directory}/key.pem";
  };

  systemd.services.kanidm = {
    requires = [ "acme-finished-idm.pas.sh.target" ];
    serviceConfig = {
      BindReadOnlyPaths = [ config.security.acme.certs."idm.pas.sh".directory ];
    };
  };

  users.users.kanidm = {
    extraGroups = [ "acme" ];
    home = "/var/lib/kanidm";
    createHome = false;
  };

  security.acme.certs."idm.pas.sh" = {
    reloadServices = [ "kanidm.service" ];
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

}
