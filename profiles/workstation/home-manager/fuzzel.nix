{ lib, nixosConfig, ... }:

with lib;

let
  colours = nixosConfig.hole.colours.fmt (c: "${c}ff");
in
{
  home.file.".config/fuzzel/fuzzel.ini".text = generators.toINI { } {
    main = {
      font = "monospace:size=10";
      icons-enabled = "no";
      terminal = "kitty";
      layer = "overlay";
    };

    colors = with colours; {
      background = bg;
      text = fg;
      match = fg;
      border = bg2;
    };
  };
}
