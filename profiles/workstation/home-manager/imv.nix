{ lib, nixosConfig, ... }:

let
  colours = nixosConfig.hole.colours;
in
{
  programs.imv.enable = true;
  programs.imv.settings = {
    options = {
      background = colours.bg;

      overlay_font = "monospace:14";

      overlay_text_color = colours.fg;
      overlay_text_alpha = "ff";

      overlay_background_color = colours.bg1;
      overlay_background_alpha = "ff";
    };
  };
}
