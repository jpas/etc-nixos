{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.programs.imv;
  cfgFmt = pkgs.formats.ini { };
in
{
  options = {
    programs.imv = {
      enable = mkEnableOption "imv";

      package = mkOption {
        type = types.package;
        default = pkgs.imv;
        defaultText = literalExample "pkgs.imv";
        description = "Which imv package to use";
      };

      settings = mkOption {
        type = cfgFmt.type;
        default = { };
        description = "Set configuration for imv (see: man 5 imv)";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ cfg.package ];

      xdg.configFile."imv/config" = mkIf (cfg.settings != { }) {
        source = cfgFmt.generate "config" cfg.settings;
      };
    })
  ];
}
