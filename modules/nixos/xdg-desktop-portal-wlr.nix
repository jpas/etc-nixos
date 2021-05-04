{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.xdg.portal.wlr;
  format = pkgs.formats.ini { };
in
{
  options = {
    xdg.portal.wlr = {
      enable = mkEnableOption "xdg-desktop-portal-wlr";

      package = mkOption {
        type = types.package;
        default = pkgs.xdg-desktop-portal-wlr;
        defaultText = "pkgs.xdg-desktop-portal-wlr";
        description = "Which xdg-desktop-portal-wlr package to use";
      };

      settings = mkOption {
        type = format.type;
        default = { };
        description = "xdg-desktop-portal-wlr configuration. See <command>man 5 xdg-desktop-portal-wlr</command> for details.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."xdg/xdg-desktop-portal-wlr/config".source =
      format.generate "config" cfg.settings;
    xdg.portal.extraPortals = [ cfg.package ];
  };
}
