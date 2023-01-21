{ lib, config, pkgs, ... }:

with lib;

let
  colours = config.hole.colours.fmt (c: "#${c}");
in
{
  programs.sway.extraPackages = [ pkgs.mako pkgs.libnotify ];

  environment.etc = mkIf config.programs.sway.enable {
    "xdg/mako/config".text = with colours; ''
      default-timeout=2000
      ignore-timeout=1

      anchor=top-right
      icons=0

      font=monospace 10
      text-color=${fg}

      background-color=${bg}
      border-color=${bg2}
      border-size=2

      [urgency=low]
      border-color=${bg1}

      [urgency=critical]
      default-timeout=0
      border-color=${neutral.red}
    '';
  };
}
