{ lib, config, pkgs, ... }:

with lib;

{
  services.kanidm.enableServer = true;
  services.kanidm.serverSettings = {
    origin = "https://idm.pas.sh";
    domain = "pas.sh";
    bindaddress = "127.0.0.1:8443";
    ldapbindaddress = "0.0.0.0:636";
    role = "WriteReplicaNoUI";

    tls_chain = "${config.security.acme.certs."idm.pas.sh".directory}/fullchain.pem";
    tls_key = "${config.security.acme.certs."idm.pas.sh".directory}/key.pem";

    trust_x_forward_for = true;
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
      loadBalancer.servers = [{ url = "https://127.0.0.1:8443"; }];
    };

    routers.kanidm = {
      rule = "Host(`idm.pas.sh`)";
      service = "kanidm";
      entryPoints = [ "web" ];
    };
  };
}
