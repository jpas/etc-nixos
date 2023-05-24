{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.lldap;
  configFile = pkgs.writeText "lldap_config.toml" ''
    ldap_host = "127.0.0.1"
    ldap_port = 3890

    http_host = "127.0.0.1"
    http_port = 17170

    http_url = "https://lldap.pas.sh"

    ldap_base_dn = "dc=pas,dc=sh"

    ldap_user_dn = "root"
    ldap_user_email = "root@pas.sh"

    database_url = "sqlite:///var/lib/lldap/users.db?mode=rwc"
    key_file = "/var/lib/lldap/private-key"
  '';
in
{
  options.services.lldap = {
    enable = mkEnableOption "lldap";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.lldap ];

    systemd.services.lldap = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        ln -sf ${pkgs.lldap}/app /var/lib/lldap
        ln -sf ${configFile} /var/lib/lldap/lldap_config.toml
      '';
      serviceConfig = {
        ExecStart = "${pkgs.lldap}/bin/lldap run";
        LimitNOFILE = 1048576;
        LimitNPROC = 64;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "full";
        WorkingDirectory = "/var/lib/lldap";
        ReadWriteDirectories = "/var/lib/lldap";
        Restart = "on-failure";
        Type = "simple";
        User = "lldap";
        Group = "lldap";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.age.secrets.lldap-jwt-secret.path;
        LLDAP_LDAP_USER_PASS = "dolphins";
      };
    };

    users.users.lldap = {
      group = "lldap";
      home = "/var/lib/lldap";
      createHome = true;
      isSystemUser = true;
    };
    users.groups.lldap = { };

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

    age.secrets.lldap-jwt-secret = {
      file = ./.lldap-jwt-secret.age;
      owner = "lldap";
    };
  };
}
