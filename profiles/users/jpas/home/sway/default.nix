{ lib
, config
, pkgs
, ...
}:

with lib;

let
  colors = config.hole.colors.gruvbox;
in
{
  imports = [ ../sway.nix ];

  config = mkMerge [
    {
      home.packages = [ pkgs.kanshi ];

      wayland.windowManager.sway = {
        config.startup = [{ command = "kanshi"; }];
      };
    }

    {
      home.packages = [ pkgs.gammastep ];

      xdg.configFile."gammastep/config.ini".text = generators.toINI { } {
        general = {
          location-provider = "manual";
          temp-day = 3600;
          temp-night = 2700;
        };

        manual = {
          lat = config.hole.location.latitude;
          lon = config.hole.location.longitude;
        };
      };

      wayland.windowManager.sway = {
        config.startup = [{ command = "gammastep"; }];
      };
    }

    {
      home.packages = [ pkgs.swaylock ];

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

    {
      home.packages = [ pkgs.swayidle pkgs.swaylock ];

      wayland.windowManager.sway = {
        config.startup = [{
          command = ''
            swayidle -w \
              idlehint 1800 \
                       lock 'swaylock -f' \
                     unlock 'pkill -QUIT -x swaylock' \
               before-sleep 'swaylock -f' \
                timeout 300 'swaylock -f' \
                timeout 600 'swaymsg "output * dpms off"' \
                     resume 'swaymsg "output * dpms on "'
          '';
        }];
      };
    }
  ];
}
