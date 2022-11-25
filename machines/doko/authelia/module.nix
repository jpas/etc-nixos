{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.authelia;

  pkg = pkgs.callPackage ./package.nix { };

  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yml" cfg.settings;
in
{
  options.services.authelia = {
    enable = mkEnableOption "Authelia";

    jwtSecretFile = mkOption {
      type = types.path;
      default = null;
      description = ''
        Path to your JWT secret used during identity verificaiton.
      '';
    };

    oidcIssuerPrivateKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your private key file used to encrypt OIDC JWTs.
      '';
    };

    oidcHmacSecretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your HMAC secret used to sign OIDC JWTs.
      '';
    };

    sessionSecretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your session secret. Only used when redis is used as session storage.
      '';
    };

    storageEncryptionKeyFile = mkOption {
      type = types.path;
      default = null;
      description = ''
        Path to your storage encryption key.
      '';
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

    environment.systemPackages = [
      pkg
    ];

    users.users.authelia = {
      isSystemUser = true;
      group = "authelia";
    };
    users.groups.authelia = {};

    systemd.services.authelia = {
      description = "Authelia authentication and authorization server";
      wantedBy = [
        "multi-user.target"
      ];
      environment = {
        AUTHELIA_JWT_SECRET_FILE = cfg.jwtSecretFile;
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = cfg.storageEncryptionKeyFile;
      } // lib.optionalAttrs (cfg.sessionSecretFile != null) {
        AUTHELIA_SESSION_SECRET_FILE = cfg.sessionSecretFile;
      } // lib.optionalAttrs (cfg.oidcIssuerPrivateKeyFile != null) {
        AUTHELIA_IDENTITY_PROVIDERS_OIDC_ISSUER_PRIVATE_KEY_FILE = cfg.oidcIssuerPrivateKeyFile;
        AUTHELIA_IDENTITY_PROVIDERS_OIDC_HMAC_SECRET_FILE = cfg.oidcHmacSecretFile;
      };
      serviceConfig = {
        User = "authelia";
        Group = "authelia";
        ExecStart = "${pkg}/bin/authelia --config ${configFile}";
      };
    };
  };
}
