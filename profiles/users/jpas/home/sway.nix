{ lib, config, nixosConfig, pkgs, ... }:

with lib;

let

  cfg = config.wayland.windowManager.sway;

  colors = config.hole.colors.gruvbox;

  menu = with colors.dark;
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

in
mkMerge [
  {
    wayland.windowManager.sway = {
      config = {
        fonts = [ "JetBrains Mono 10" ];

        modifier = "Mod4";
        terminal = "kitty";
        workspaceAutoBackAndForth = true;

        window.titlebar = true;
        floating.titlebar = true;

        window.commands = [
          {
            criteria = {
              title = "\\ -\\ Sharing\\ Indicator$";
            };
            command = "border none, floating enable, sticky enable";
          }
        ];

        output."*".bg = "~/.config/sway/bg.png fill";

        startup = [
          #{
          #  # TODO: add a systemd user service for swayidle
          #  command = ''
          #    swayidle -w \
          #      timeout 300 swaylock \
          #      timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
          #      before-sleep swaylock
          #  '';
          #  # This will lock your screen after 300 seconds of inactivity,
          #  # then turn off your displays after another 300 seconds, and turn
          #  # your screens back on when resumed. It will also lock your
          #  # screen before your computer goes to sleep.
          #}
        ];

        keybindings =
          let modifier = cfg.config.modifier;
          in
          lib.mkOptionDefault {
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

        colors =
          let
            color = text: indicator: c: {
              inherit text indicator;
              border = c;
              childBorder = c;
              background = c;
            };
          in
          with colors.dark; rec {
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

          fonts = cfg.config.fonts;

          statusCommand =
            "while date +'%Y-%m-%d %l:%M:%S %p '; do sleep 1; done";

          colors =
            let
              color = text: c: {
                inherit text;
                border = c;
                background = c;
              };
            in
            with colors.dark; rec {
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

        input = {
          "type:keyboard" = {
            xkb_options = "caps:escape";
          };
        };
      };

      extraConfig = ''
        seat * pointer_constraint disable
      '';
    };
  }

  (mkIf cfg.enable {
    home.packages = with pkgs; [
      dmenu # needed for dmenu_path
      bemenu
      pamixer
      pavucontrol
      playerctl
      sway-contrib.grimshot
      volatile.wdomirror
      wl-clipboard
      (pkgs.symlinkJoin {
        name = "sway-stuff";
        paths = [ menu ];
      })
    ];

  })

  (mkIf nixosConfig.programs.sway.enable {
    wayland.windowManager.sway.package = null;
  })
]
