{ lib
, config
, pkgs
, ...
}:

with lib;

let
  colors = config.hole.colors.gruvbox;

  mkStartupCommand = { command, always ? false, packages ? [ ] }: {
    home.packages = packages;
    wayland.windowManager.sway.config.startup = [{
      inherit command always;
    }];
  };
in
{
  imports = [ ../sway.nix ];

  config = mkMerge [
    {
      home.packages = [ pkgs.wlsunset ];
      wayland.windowManager.sway.config.startup = [{
        command = ''
          sleep 0.5; pkill wlsunset; \
          exec wlsunset -t 3000 -T 5000 -l 52.1 -L -106.4
        '';
        always = true;
      }];
    }

    {
      home.packages = with pkgs; [
        swaylock
        swayidle
        (writeShellScriptBin "screen-lock" ''
          swaylock -f
        '')
        (writeShellScriptBin "screen-unlock" ''
          pkill -QUIT -x swaylock
        '')
        (writeShellScriptBin "screen-on" ''
          swaymsg output '*' dpms on
        '')
        (writeShellScriptBin "screen-off" ''
          swaymsg output '*' dpms off
        '')
      ];

      wayland.windowManager.sway.config = {
        startup = [{
          always = true;
          command = ''
            pkill swayidle; \
            exec swayidle -w \
              idlehint 1800 \
                       lock screen-lock \
                     unlock screen-unlock \
               before-sleep screen-lock \
               timeout  300 screen-lock \
               timeout 3600 screen-off resume screen-on
          '';
        }];
      };

      xdg.configFile."swaylock/config" = {
        text = with colors.dark-no-hash; ''
          font=JetBrain Mono
          text-color=${fg}

          color=${bg}

          key-hl-color=${fg}
          bs-hl-color=${red1}
          caps-lock-bs-hl-color=${red1}
          caps-lock-key-hl-color=${yellow1}

          inside-color=${bg}
          inside-clear-color=${bg}
          inside-caps-lock-color=${bg}
          inside-ver-color=${bg}
          inside-wrong-color=${bg}

          line-uses-inside

          ring-color=${bg}
          ring-ver-color=${green1}
          ring-clear-color=${yellow1}
          ring-wrong-color=${red1}

          text-color=${bg}
          text-clear-color=${bg}
          text-caps-lock-color=${bg}
          text-ver-color=${bg}
          text-wrong-color=${bg}
        '';
      };
    }
  ];
}
