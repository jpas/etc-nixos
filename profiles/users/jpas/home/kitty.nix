{ lib, config, ... }:

with lib;

let

  colors = config.hole.colors.gruvbox.dark;

in {
  programs.kitty = {
    font.name = "JetBrains Mono"; # TODO: use default monospace?

    settings = {
      font_size = 10;

      enable_audio_bell = false;
      visual_bell_duration = 0;

      window_padding_width = 3;
      placement_strategy = "center";

      background = colors.bg;
      foreground = colors.fg;

      cursor = colors.fg;
      cursor_text_color = "background";

      color0 = elemAt colors.console 0;
      color1 = elemAt colors.console 1;
      color2 = elemAt colors.console 2;
      color3 = elemAt colors.console 3;
      color4 = elemAt colors.console 4;
      color5 = elemAt colors.console 5;
      color6 = elemAt colors.console 6;
      color7 = elemAt colors.console 7;

      color8 = elemAt colors.console 8;
      color9 = elemAt colors.console 9;
      color10 = elemAt colors.console 10;
      color11 = elemAt colors.console 11;
      color12 = elemAt colors.console 12;
      color13 = elemAt colors.console 13;
      color14 = elemAt colors.console 14;
      color15 = elemAt colors.console 15;

      linux_display_server = "auto";
    };
  };
}
