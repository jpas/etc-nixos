{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.authelia;

  pkg = pkgs.callPackage ./package.nix { };

  format = pkgs.formats.yaml { };
in
{
  options.services.authelia = {
    enable = mkEnableOption "Authelia";

    configFile = mkOption {
      type = types.path;
      default = format.generate "config.yml" cfg.settings;
    };

    address = mkOption {
      readOnly = true;
      default = "${cfg.settings.server.host}:${toString cfg.settings.server.port}";
    };

    settings = mkOption {
      description = ''
        Your Authelia config.yml as a Nix attribute set.

        https://github.com/authelia/authelia/blob/master/config.template.yml
      '';
      type = types.submodule {
        freeformType = format.type;
        options = {
          default_2fa_method = mkOption {
            type = types.enum [ "" "totp" "webauthn" "mobile_push" ];
            default = "";
            example = "webauthn";
            description = ''
              Default 2FA method for new users and fallback for preferred but disabled methods.
            '';
          };

          server = {
            host = mkOption {
              type = types.str;
              default = "localhost";
              example = "0.0.0.0";
              description = ''
              '';
            };

            port = mkOption {
              type = types.port;
              default = 9091;
              description = ''
              '';
            };
          };

          log = {
            level = mkOption {
              type = types.enum [ "info" "debug" "trace" ];
              default = "info";
              example = "debug";
              description = ''
              '';
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkg ];

    systemd.services.authelia = {
      description = "Authelia authentication and authorization server";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkg}/bin/authelia --config ${cfg.configFile}";
        LimitNOFILE = 1048576;
        LimitNPROC = 64;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "full";
        ReadWriteDirectories = "/var/lib/authelia";
        Restart = "on-failure";
        Type = "simple";
        User = "authelia";
        Group = "authelia";
      };
    };

    systemd.tmpfiles.rules = [ "d /var/lib/authelia 0700 authelia authelia - -" ];

    users.users.authelia = {
      group = "authelia";
      home = "/var/lib/authelia";
      createHome = true;
      isSystemUser = true;
    };
    users.groups.authelia = { };
  };
}
