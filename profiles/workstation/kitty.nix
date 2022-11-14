{ lib, pkgs, ... }:

with lib;

let
  colours = config.hole.colours.fmt (c: "#${c}");
in
{
  environment.systemPackages = [ pkgs.kitty ];

  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family monospace
    font_size = 10.0

    placement_strategy center

    remember_window_size no
    initial_window_width 800
    initial_window_height 600

    cursor none

    foreground ${colours.fg}
    background ${colours.bg}
    selection_foreground none
    selection_background none

    window_padding_width 3

    enable_audio_bell no

    ${concatMapStringsSep "\n" (mapAttrsToList (c: h: "color${removePrefix "c" n} ${h}") colours.ansi)}

    linux_display_server auto
  '';
}
