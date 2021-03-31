{ lib
, config
, nixosConfig
, pkgs
, ...
}:

with lib;

let
  cfg = config.wayland.windowManager.sway;

  colors = config.hole.colors.gruvbox;

  menu = with colors.dark;
    pkgs.writeShellScriptBin "menu-old" ''
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

        window.commands = [
          { command = "floating enable; sticky enable; border pixel 2"; criteria = { app_id = "menu"; };}
        ];
        floating.titlebar = true;

        output."*".bg = "~/.config/sway/bg.png fill";

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
              "exec menu menu-path 'xargs -r swaymsg -t command exec --'";

            "${modifier}+p" = ''
                exec menu \
                  menu-pdfs \
                  "xargs -r swaymsg -t command exec zathura --" \
                  "--delimiter / --with-nth -1"
            '';
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
    };
  }

  (mkIf cfg.enable {
    home.packages = with pkgs; [
      pamixer
      playerctl
      sway-contrib.grimshot
      volatile.wdomirror
      wl-clipboard
    ];
  })

  (mkIf nixosConfig.programs.sway.enable {
    wayland.windowManager.sway.package = null;
  })
]
