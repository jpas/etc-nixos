{ lib, config, pkgs, ... }:

with lib;

let
  colours = config.hole.colours;
in
{
  programs.sway = {
    extraPackages = attrValues {
      inherit (pkgs)
        grim
        kanshi
        slurp
        wl-clipboard
        ;
    };
  };

  xdg.portal.wlr.enable = mkDefault true;
  #xdg.portal.wlr.settings.screencast = {
  #  chooser_type = mkDefault "simple";
  #  chooser_cmd = mkDefault (with config.hole.colours; concatStringsSep " " [
  #    "${pkgs.slurp}/bin/slurp -or"
  #    "-f %o"
  #    "-b ${bg}00"
  #    "-c ${normal.aqua}ff"
  #    "-s ${normal.aqua}7f"
  #    "-B ${bg}00"
  #    "-w 2"
  #  ]);
  #};
}
