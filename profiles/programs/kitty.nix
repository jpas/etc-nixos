{ lib, config, pkgs, ... }:

with lib;

let
  colours = config.hole.colours.fmt (c: "#${c}");
in
{
  environment.systemPackages = [ pkgs.kitty ];

  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family monospace
    font_size 10.0

    initial_window_height 600
    initial_window_width 800
    placement_strategy center
    remember_window_size no
    scrollback_fill_enlarged_window yes

    cursor none

    foreground ${colours.fg}
    background ${colours.bg}
    selection_foreground none
    selection_background none

    window_padding_width 3

    enable_audio_bell no

    ${concatStringsSep "\n" (mapAttrsToList (c: h: "color${removePrefix "c" c} ${h}") colours.ansi)}

    linux_display_server auto
  '';
}
