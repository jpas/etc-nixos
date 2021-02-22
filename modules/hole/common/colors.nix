{ lib, ... }:

with lib;

let
  gruvbox = let
    dark' = [ "3c3836" "504945" "665c54" "7c6f64" ];
    dark-hard = [ "1d2021" ] ++ dark';
    dark = [ "282828" ] ++ dark';
    dark-soft = [ "1d2021" ] ++ dark';

    light' = [ "ebdbb2" "d5c4a1" "bdae93" "a89984" ];
    light-hard = [ "f9f5d7" ] ++ light';
    light = [ "fbf1c7" ] ++ light';
    light-soft = [ "f2e5bc" ] ++ light';

    gray = "928374";

    bright = {
      red = "fb4934";
      green = "b8bb26";
      yellow = "fabd2f";
      blue = "83a598";
      purple = "d3869b";
      aqua = "8ec07c";
      orange = "fe8019";
    };

    neutral = {
      red = "cc241d";
      green = "98971a";
      yellow = "d79921";
      blue = "458588";
      purple = "b16286";
      aqua = "689d6a";
      orange = "d65d0e";
    };

    faded = {
      red = "9d0006";
      green = "79740e";
      yellow = "b57614";
      blue = "076678";
      purple = "8f3f71";
      aqua = "427b58";
      orange = "af3a03";
    };

    mkConsole = theme: [
      theme.bg
      theme.red0
      theme.green0
      theme.yellow0
      theme.blue0
      theme.purple0
      theme.aqua0
      theme.fg4
      theme.gray
      theme.red1
      theme.green1
      theme.yellow1
      theme.blue1
      theme.purple1
      theme.aqua1
      theme.fg
    ];

    mkTheme = { bg, fg, normal, accent }:
      fmt:
      let
        bg' = elemAt (map fmt bg);
        fg' = elemAt (map fmt fg);
        normal' = mapAttrs (_: rgb: fmt rgb) normal;
        accent' = mapAttrs (_: rgb: fmt rgb) accent;
        gray' = fmt gray;
        self = {
          bg = bg' 0;
          bg0 = bg' 0;
          bg1 = bg' 1;
          bg2 = bg' 2;
          bg3 = bg' 3;
          bg4 = bg' 4;

          gray = gray';

          fg = fg' 1;
          fg0 = fg' 0;
          fg1 = fg' 1;
          fg2 = fg' 2;
          fg3 = fg' 3;
          fg4 = fg' 4;

          red0 = normal'.red;
          red1 = accent'.red;
          green0 = normal'.green;
          green1 = accent'.green;
          yellow0 = normal'.yellow;
          yellow1 = accent'.yellow;
          blue0 = normal'.blue;
          blue1 = accent'.blue;
          purple0 = normal'.purple;
          purple1 = accent'.purple;
          aqua0 = normal'.aqua;
          aqua1 = accent'.aqua;
          orange0 = normal'.orange;
          orange1 = accent'.orange;
        };
      in self // { console = mkConsole self; };

    dark-theme = mkTheme {
      bg = dark;
      fg = light;
      normal = neutral;
      accent = bright;
    };
    light-theme = mkTheme {
      bg = light;
      fg = dark;
      normal = neutral;
      accent = faded;
    };

    hashRGB = rgb: "#" + rgb;
  in {
    dark = dark-theme hashRGB;
    dark-no-hash = dark-theme id;

    light = light-theme hashRGB;
    light-no-hash = light-theme id;
  };

in {
  options = {
    hole = {
      colors = mkOption {
        type = types.anything;
        default = { inherit gruvbox; };
        readOnly = true;
      };
    };
  };
}
