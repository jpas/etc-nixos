{ lib, config, ... }:

with lib;

let gruvbox = config.hole.colors.gruvbox.dark;
in {
  programs.kitty = {
    font.name = "JetBrains Mono"; # TODO: use default monospace?

    settings = {
      font_size = 10;

      enable_audio_bell = false;
      visual_bell_duration = 0;

      window_padding_width = 3;
      placement_strategy = "center";

      background = gruvbox.bg;
      foreground = gruvbox.fg;

      cursor = gruvbox.fg;
      cursor_text_color = "background";

      color0 = elemAt gruvbox.console 0;
      color1 = elemAt gruvbox.console 1;
      color2 = elemAt gruvbox.console 2;
      color3 = elemAt gruvbox.console 3;
      color4 = elemAt gruvbox.console 4;
      color5 = elemAt gruvbox.console 5;
      color6 = elemAt gruvbox.console 6;
      color7 = elemAt gruvbox.console 7;

      color8 = elemAt gruvbox.console 8;
      color9 = elemAt gruvbox.console 9;
      color10 = elemAt gruvbox.console 10;
      color11 = elemAt gruvbox.console 11;
      color12 = elemAt gruvbox.console 12;
      color13 = elemAt gruvbox.console 13;
      color14 = elemAt gruvbox.console 14;
      color15 = elemAt gruvbox.console 15;

      linux_display_server = "auto";
    };
  };
}
