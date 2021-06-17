{ lib
, config
, pkgs
, ...
}:

with lib;

let
  inherit (config.users) users;

  cfg = config.security;

  secret = types.submodule ({ config, ... }: {
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
        readOnly = true;
        description = ''
          Path which the file is decrypted to.
        '';
      };

      mode = mkOption {
        type = types.str;
        default = "u+r";
      };

      owner = mkOption {
        type = types.str;
        default = "root";
      };

      group = mkOption {
        type = types.str;
        default = users.${config.owner}.group or "root";
      };

      before = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  });

  passwordFiles = remove null (mapAttrsToList (_: u: u.passwordFile) users);
  #isPasswordFile = elem passwordFiles;

  age = "${pkgs.age}/bin/age";

  decryptFile = ''
  '';

  makeDecryptKeys = keys:
    pkgs.writeText "keys.sh" (concatMapStringsSep "\n"
      (key: ''
        decryptKey "${key.file}" "${key.path}"
      '')
      keys);

  makeApplyOwnerModes = keys:
    pkgs.writeText "keys-chmod-chown.sh" (concatMapStringsSep "\n"
      (key: ''
        chmod 0000 "${key.path}"
        decryptKey "${key.file}" "${key.path}"
      '')
      keys);

in
{
  options = {
    secrets.keys = mkOption {
      type = types.attrsOf secret;
      default = { };
    };

    secrets.age.identities = mkOption {
      type = types.listOf identity;
      default = [ ];
    };

    secrets.age.package = mkOption {
      type = types.packages;
      default = pkgs.age;
    };
  };

  config = mkIf (true || cfg.keys != { }) {
    system.activationScripts = {
      users.deps = [ "run-keys-decrypt-passwd" ];

      # specialfs ensures that /run/keys is mounted
      run-keys-decrypt-passwd = stringAfter [ "specialfs" ] ''
        echo "${toString passwordFiles}"
        #echo "decrypting /run/keys..."
        #decryptKey() {
        #  local source="$1"
        #  local dest="$2"
        #  local tmpfile="$dest.tmp"

        #  mkdir --parents "$(dirname "$dest")"
        #  (
        #    umask u=r,g=,o=
        #    LANG=${config.i18n.defaultLocale} ${pkgs.age}/bin/age --decrypt \
        #      --identity /etc/ssh/ssh_host_ed25519_key \
        #      --output "$tmpfile" "$source"
        #  )
        #  mv --force "$tmpfile" "$dest"
        #}
      '';

      run-keys-decrypt = stringAfter [ "users" "groups" ] ''
        echo "decrypting /run/keys..."
        #applyOwnerMode() {
        #  local key="$1"
        #  local owner="$2"
        #  local group="$3"
        #  local mode="$4"

        #  chmod 0000 "$key"
        #  chmod "$mode" "$key"
        #  chown "$owner:$group" "$key"
        #}
      '';
    };
  };
}
