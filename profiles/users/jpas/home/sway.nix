{ lib, config, nixosConfig, pkgs, ... }:

with lib;

let

  sway = config.wayland.windowManager.sway;

  gruvbox = config.hole.colors.gruvbox;

  menu = with gruvbox.dark;
    pkgs.writeShellScriptBin "menu" ''
      export BEMENU_BACKEND=wayland
      exec bemenu -b -m -1 \
        --fn "JetBrains Mono 10" \
        --line-height 24 \
        --nf=${fg} \
        --nb=${bg} \
        --hf=${bg} \
        --hb=${aqua0} \
        --ff=${fg} \
        --fb=${bg} \
        --tb=${bg2} \
        --tf=${fg} "$@"
    '';

in mkMerge [
  (mkIf sway.enable {
    home.packages = with pkgs; [
      sway-contrib.grimshot
      pavucontrol
      pamixer
      playerctl
      (pkgs.symlinkJoin {
        name = "sway-stuff";
        paths = [ menu ];
      })
    ];

    wayland.windowManager.sway = {
      config = {
        fonts = [ "JetBrains Mono 10" ];
        gaps.inner = 2;

        modifier = "Mod4";
        terminal = "kitty";
        workspaceAutoBackAndForth = true;

        window.titlebar = true;
        floating.titlebar = true;

        output."*".bg = "~/.config/sway/bg.png fill";

        startup = [
          {
            command = "systemctl restart --user kanshi";
            always = true;
          }
          {
            # TODO: add a systemd user service for swayidle
            command = ''
              swayidle -w \
                timeout 300 swaylock \
                timeout 600 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                before-sleep swaylock
            '';
            # This will lock your screen after 300 seconds of inactivity,
            # then turn off your displays after another 300 seconds, and turn
            # your screens back on when resumed. It will also lock your
            # screen before your computer goes to sleep.
          }
        ];

        keybindings = let modifier = sway.config.modifier;
        in lib.mkOptionDefault {
          # Screenshots:
          "Print" = "exec grimshot copy area";
          "Shift+Print" = "exec grimshot save area";

          # Multimedia controls:
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";

          # Brightness controls:
          #"XF86MonBrightnessUp" = "";
          #"XF86MonBrightnessDown" = "";

          # Volume controls:
          "XF86AudioMute" = "exec pamixer --toggle-mute";
          "XF86AudioLowerVolume" = "exec pamixer --decrease 5";
          "XF86AudioRaiseVolume" = "exec pamixer --increase 5";

          "${modifier}+d" =
            "exec dmenu_path | menu --prompt='|>' | xargs swaymsg exec --";
        };

        colors = let
          color = text: indicator: c: {
            inherit text indicator;
            border = c;
            childBorder = c;
            background = c;
          };
        in with gruvbox.dark; rec {
          background = bg;

          focused = color fg aqua1 bg2;
          unfocused = color fg2 bg1 bg1;
          placeholder = unfocused;
          focusedInactive = unfocused;
          urgent = color fg red0 red0;
        };

        bars = [{
          extraConfig = ''
            tray_output primary
            tray_padding 2
            separator_symbol "|"
          '';

          fonts = sway.config.fonts;

          statusCommand =
            "while date +'%Y-%m-%d %l:%M:%S %p '; do sleep 1; done";

          colors = let
            color = text: c: {
              inherit text;
              border = c;
              background = c;
            };
          in with gruvbox.dark; rec {
            statusline = fg;
            background = bg;
            separator = bg2;

            focusedWorkspace = color fg bg2;
            activeWorkspace = focusedWorkspace;
            inactiveWorkspace = color fg2 bg1;
            urgentWorkspace = color fg red0;
            bindingMode = color fg yellow0;
          };
        }];
      };

      extraConfig = ''
        seat * pointer_constraint disable
      '';
    };

    services.kanshi.enable = true;
    services.gammastep.enable = true;

    xdg.configFile."swaylock/config" = {
      text = with gruvbox.dark-no-hash; ''
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
  })

  (mkIf nixosConfig.programs.sway.enable {
    wayland.windowManager.sway.package = null;
  })
]
