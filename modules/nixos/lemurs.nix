{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.lemurs;

  toml = pkgs.formats.toml { };
  configFile = toml.generate "lemurs-config.toml" cfg.settings;

  environment = types.submodule ({ config, name, ... }: {
    options = {
      name = mkOption {
        default = name;
      };
      text = mkOption {
        type = types.lines;
      };
      file = mkOption {
        type = types.path;
        default = pkgs.writeShellScript "lemurs-${config.type}-${config.name}" config.text;
      };
      type = mkOption {
        type = types.enum [ "x11" "wayland" ];
      };
      path = mkOption {
        internal = true;
        default = let dir = if config.type == "x11" then "wms" else config.type; in "lemurs/${dir}/${config.name}";
      };
    };
  });
in
{
  options.services.lemurs = {
    enable = mkEnableOption "lemurs tty based display manager";

    package = mkOption {
      type = types.package;
      default = pkgs.lemurs;
    };

    settings = mkOption {
      type = types.attrs;
      apply = recursiveUpdate (importTOML "${cfg.package}/etc/config.toml");
    };

    environments = mkOption {
      type = types.attrsOf environment;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lemurs = {
      after = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
        "getty@tty${toString cfg.settings.tty}.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "idle";
        ExecStart = "${cfg.package}/bin/lemurs --config ${configFile}";
        StandardInput = "tty";
        TTYPath = "/dev/tty${toString cfg.settings.tty}";
        TTYReset = true;
        TTYVHangup = true;
      };
    };

    environment.etc = flip mapAttrs' cfg.environments
      (_: env: nameValuePair env.path { source = env.file; });
  };
}
