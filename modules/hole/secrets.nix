{ lib
, config
, pkgs
, ...
}:

with lib;

let
  #hosts = config.hole.hosts;
  cfg = config.hole.secrets;

  secret = types.submodule {
    options = {
      source = mkOption {
        type = types.path;
      };

      destination = mkOption {
        type = types.str;
      };

      owner = mkOption {
        type = types.str;
        default = "root";
      };

      group = mkOption {
        type = types.str;
        default = "root";
      };

      permissions = mkOption {
        type = types.str;
        default = "0400";
      };
    };
  };

  mkSecret = { name, source, ... }: pkgs.stdenv.mkDerivation {
    name = "${name}.age";
    phases = "installPhase";
    buildInputs = [ pkgs.rage ];
    installPhase =
      let
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWAg8IMKXHkRkGLmhFH4eWfVtS1qbhHP2Vd3B53JtGL";
      in ''
        rage --encrypt \
          --recipient '${key}' \
          --output "$out" \
          '${source}'
      '';
  };

in
{
  options = {
    hole.secrets = mkOption {
      type = types.attrsOf secret;
      default = {
        testing = {
          source = /etc/nixos/secrets/testing-secret;
          destination = "";
        };
      };
    };
  };

  config = {
    environment.systemPackages = lib.attrValues
      (lib.mapAttrs (name: secret: mkSecret (secret // { inherit name; })));
  };
}
