{ config, lib, pkgs, modulesPath, ... }:

with lib;

let

  nixosConfig = config;
  nixosCfg = nixosConfig.security.pam-new;

  pamRule = { config, name, ... }: {
    name = mkOption {
      type = types.str;
    };

    control = mkOption {
      type = types.str;
      default = "required";
    };

    path = mkOption {
      type = types.str;
      default = "pam_${name}.so";
    };

    arguments = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    before = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    after = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };

  pamRules = types.attrsOf (types.submodule pamRule);

  pamService = { config, name, ... }: {
    name = mkOption {
      type = types.str;
    };

    base = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    account = mkOption {
      type = pamRules;
      default = { };
    };

    auth = mkOption {
      type = pamRules;
      default = { };
    };

    password = mkOption {
      type = pamRules;
      default = { };
    };

    session = mkOption {
      type = pamRules;
      default = { };
    };
  };

in
{
  options.security.pam-new = {
    services = mkOption {
      type = with types; attrsOf (submodule pamService);
      default = {
        other = rec {
          account = {
            deny = { };
            warn.before = [ "deny" ];
          };
          auth = account;
          password = account;
          session = account;
        };
      };
    };
  };

  config = {
    security.pam-new.services = {
      other = flip genAttrs [ "account" "auth" "password" "session" ] (_: {
        ${name} = {
          deny.control = "required";
          warn.control = "required";
          warn.before = [ "deny" ];
        };
      });
    };
  };
}
