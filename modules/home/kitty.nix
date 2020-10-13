{ ... }:
let
  hasGUI = (import <nixpkgs/nixos> {}).config.services.xserver.enable;
in
{
  programs.kitty = {
    enable = hasGUI;

    font.name = "JetBrains Mono"; # TODO: use default monospace?

    settings = {
      font_size = 9;

      enable_audio_bell = false;
      visual_bell_duration = 0;

      window_padding_width = 3;
      placement_strategy = "center";

      background = "#282828";
      foreground = "#ebdbb2";

      cursor = "#ebdbb2";
      cursor_text_color = "background";

      color0 = "#3c3836";
      color1 = "#cc241d";
      color2 = "#98971a";
      color3 = "#d79921";
      color4 = "#458588";
      color5 = "#b16286";
      color6 = "#689d6a";
      color7 = "#a89984";

      color8 = "#928374";
      color9 = "#fb4934";
      color10 = "#b8bb26";
      color11 = "#fabd2f";
      color12 = "#83a598";
      color13 = "#d3869b";
      color14 = "#8ec07c";
      color15 = "#fbf1c7";

      linux_display_server = "auto";
    };
  };
}
