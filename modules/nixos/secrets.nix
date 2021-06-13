{ lib
, ...
}:

with lib;

let
  key = types.submodule ({ config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = config._module.args.name;
      };

      file = mkOption {
        type = types.path;
      };

      path = mkOption {
        type = types.str;
        default = "/run/keys/${config.name}";
      };

      mode = mkOption {
        type = types.str;
        default = "0440";
      };

      group = mkOption {
        type = types.str;
        default = "0";
      };
    };
  });
in
{
  #options = {
  #  security.keys = mkOption {
  #    type = types.attrsOf secret;
  #    default = { };
  #  };
  #};

  config = {
    system.activationScripts = {
      users.deps = [ "decrypt-run-keys-early" ];
      decrypt-run-keys-early = stringAfter [ "specialfs" ] ''
        echo "decrypting early /run/keys..."
      '';

      decrypt-run-keys = stringAfter [ "specialfs" "users" "groups" ] ''
        echo "decrypting /run/keys..."
      '';
    };
  };
}
