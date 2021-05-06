{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.programs.oauth2ms;

  format = pkgs.formats.json { };
in
{
  options = {
    programs.oauth2ms = {
      enable = mkEnableOption "oauth2ms";

      settings = mkOption {
        type = format.type;
        default = { };
      };

      package = mkOption {
        type = types.package;
        default = pkgs.oauth2ms;
        defaultText = "pkgs.oauth2ms";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."oauth2ms/config.json" = mkIf (cfg.settings != { }) {
      source = format.generate "config.json" cfg.settings;
    };
  };
}
