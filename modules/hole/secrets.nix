{ lib
, config
, pkgs
, ...
}:

with lib;

let
  #hosts = config.hole.hosts;
  cfg = config.hole.secrets;

  secret = types.submodule
    { config, ... }: {
      options = {
        name = mkOption {
          type = types.str;
          defaultText = "name of attribute";
        };

        source = mkOption {
          type = types.path;
        };

        path = mkOption {
          type = types.str;
          default = "/run/secrets/${config.name}";
          defaultText = "/run/secrets/<name>";
        };

        owner = mkOption {
          type = types.str;
          default = "root";
        };

        group = mkOption {
          type = types.str;
          default = "root";
        };

        mode = mkOption {
          type = types.str;
          default = "0400";
        };
      };
    };

  activateSecret = secret: ''
    tmp="${secret.path}.tmp"
    mkdir -p "$(dirname ${lib.escapeShellArg secret.path})"
    ${pkgs.rage}/bin/rage -d -i '${identity}' -o '${destination}' '${source}'
  '';

in
{
  options = {
    hole.secrets = mkOption {
      type = types.attrsOf secret;
      default = {
        testing = {
          name = "testing-secret";
          source = ./secrets/testing-secret.age;
        };
      };
    };
  };

  config = {
    environment.systemPackages = attrValues (flip mapAttrs cfg
      (name: secret: mkSecret (secret // { inherit name; }))
    );
  };
}
