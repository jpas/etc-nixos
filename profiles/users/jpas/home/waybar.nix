{ lib, config, ... }:

with lib;

let
  sway = config.wayland.windowManager.sway;
  waybar = config.programs.waybar;
in mkMerge [
  {
    programs.waybar = {
      systemd.enable = true;

      settings = [{
        layer = "top";
        position = "bottom";

        modules-left = [ "sway/window" ];

        modules-center = [ "sway/workspaces" "sway/mode" ];

        modules-right = [ "clock" ];
      }];
    };
  }

  (mkIf waybar.enable {
    wayland.windowManager.sway = {
      config = {
        startup = [{
          command = "systemctl restart --user waybar";
          always = true;
        }];
      };
    };
  })
]
