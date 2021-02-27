{ lib, config, ... }:

with lib;

let

  cfg = config.programs.mako;

  colors = config.hole.colors.gruvbox.dark;

in mkMerge [
  {
    programs.mako = {
      font = "JetBrains Mono 10";

      anchor = "bottom-right";

      textColor = colors.fg;
      backgroundColor = colors.bg;
      borderColor = colors.bg2;
      borderSize = 3;

      icons = false;
    };
  }

  (mkIf config.programs.mako.enable { })
]
