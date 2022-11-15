{ lib, nixosConfig, ... }:

with lib;

let
  colours = nixosConfig.hole.colours.fmt (c: "#${c}");
in
{
  programs.kitty.enable = false;
  programs.kitty.font.name = "monospace";
  programs.kitty.settings = {
    font_size = 10;

    enable_audio_bell = false;
    visual_bell_duration = 0;

    remember_window_size = false;
    initial_window_width = 800;
    initial_window_height = 600;
    window_padding_width = 3;
    placement_strategy = "center";

    background = colours.bg;
    foreground = colours.fg;

    cursor = colours.fg;
    cursor_text_color = "background";

    color0 = colours.vt0;
    color1 = colours.vt1;
    color2 = colours.vt2;
    color3 = colours.vt3;
    color4 = colours.vt4;
    color5 = colours.vt5;
    color6 = colours.vt6;
    color7 = colours.vt7;

    color8 = colours.vt8;
    color9 = colours.vt9;
    color10 = colours.vt10;
    color11 = colours.vt11;
    color12 = colours.vt12;
    color13 = colours.vt13;
    color14 = colours.vt14;
    color15 = colours.vt15;

    linux_display_server = "auto";
  };
}
