{ lib
, config
, ...
}:

with lib;

let
  cfg = config.programs.imv;
  color = config.hole.colors.gruvbox.dark-no-hash;
in
mkMerge [
  {
    programs.imv = {
      settings = {
        options = {
          background = color.bg;

          overlay_font = "monospace:14";

          overlay_text_color = color.fg;
          overlay_text_alpha = "ff";

          overlay_background_color = color.bg1;
          overlay_background_alpha = "ff";
        };
      };
    };
  }

  (mkIf cfg.enable {
    wayland.windowManager.sway = {
      config = rec {
        floating.criteria = [{ app_id = "imv"; }];

        window.commands = [{
          criteria = { app_id = "imv"; };
          command = "border normal";
        }];
      };
    };
  })
]
