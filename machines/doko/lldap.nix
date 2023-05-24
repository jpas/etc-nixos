{ lib, config, pkgs, ... }:

with lib;

{
  services.lldap.enable = true;

  services.lldap.settings = {
    ldap_host = "127.0.0.1";
    ldap_port = 3890;

    http_host = "127.0.0.1";
    http_port = 17170;

    http_url = "https://lldap.pas.sh";

    ldap_base_dn = "dc=pas,dc=sh";

    ldap_user_dn = "root";
    ldap_user_email = "root@pas.sh";

    database_url = "sqlite:///var/lib/lldap/users.db?mode=rwc";
    key_file = "/var/lib/lldap/private-key";

    environment = {
      LLDAP_JWT_SECRET_FILE = "%d/jwt-secret";
      LLDAP_LDAP_USER_PASS = "dolphins"; # TODO: fix me
    };
  };

  systemd.services.lldap = {
    serviceConfig = {
      LoadCredential = [
        "jwt-secret:${config.age.secrets.lldap-jwt-secret.path}"
      ];
    };
  };

  services.caddy.virtualHosts = {
    "lldap.o.pas.sh" = {
      useACMEHost = "o.pas.sh";
      extraConfig = ''
        reverse_proxy 127.0.0.1:17170
      '';
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.lldap = {
      loadBalancer.servers = [{ url = "http://127.0.0.1:17170"; }];
    };

    routers.lldap = {
      rule = "Host(`lldap.o.pas.sh`)";
      service = "lldap";
      entryPoints = [ "web" ];
      middlewares = [ "tailscale-ips" ];
    };
  };

  age.secrets.lldap-jwt-secret.file = ./.lldap-jwt-secret.age;
}
