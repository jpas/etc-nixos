{ lib, config, pkgs, ... }:

with lib;

mkIf config.hole.profiles.graphical {
  home.packages = [ pkgs.signal-desktop ];

  wayland.windowManager.sway.config = {
    floating.criteria = [{ class = "Signal"; }];
  };
}
