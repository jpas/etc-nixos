{ lib, config, pkgs, ... }:

with lib;

mkIf config.wayland.windowManager.sway.enable {
  home.packages = [ pkgs.libnotify ];

  programs.mako = with colours; {
    font = "monospace 10";
    anchor = "bottom-right";

    textColor = fg;
    backgroundColor = bg;
    borderColor = bg2;
    borderSize = 2;

    icons = false;

    defaultTimeout = 2000;
    extraConfig = ''
      ignore-timeout=1

      [urgency=low]
      border-color=${bg1}

      [urgency=critical]
      default-timeout=0
      border-color=${bright.red}
    '';
  };
}
