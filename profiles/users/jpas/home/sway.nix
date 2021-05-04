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

  swayConfig = {
    fonts = [ "JetBrains Mono 10" ];

    modifier = "Mod4";
    workspaceAutoBackAndForth = true;

    input = {
      "type:keyboard" = {
        xkb_options = "caps:escape";
      };
      "type:touchpad" = {
        tap = "enabled";
      };
    };

    output."*".bg = "~/.config/sway/bg.png fill";

    floating.titlebar = true;

    window.titlebar = true;
    window.commands = [
      {
        criteria = { app_id = "menu"; };
        command = "floating enable; sticky enable; border pixel 2";
      }
      {
        criteria = { class = "explorer.exe"; };
        command = "floating enable; border pixel 2";
      }
      { criteria = { class = "^.*"; }; command = "inhibit_idle fullscreen"; }
      { criteria = { app_id = "^.*"; }; command = "inhibit_idle fullscreen"; }
    ];

    keybindings = let inherit (cfg.config) modifier; in
      mkOptionDefault {
        # Switch display mode
        # XXX: Dell XPS 9300's media key to "switch displays" has odd
        # behaviour holding fn then pressing f8 beings holding Mod4, then
        # taps p. Continuing to tap f8 results in more taps of p. Once fn
        # is released Mod4 will be released.
        #"Mod4+p" = "";

        "${modifier}+d" =
          "exec menu menu-path 'xargs -r swaymsg -t command exec --'";

        "${modifier}+o" = ''
          exec menu \
            menu-pdfs \
            "xargs -r swaymsg -t command exec zathura --" \
            "--delimiter / --with-nth -1"
        '';
      };

    colors = with colors.dark; rec {
      background = bg;
      focused = mkClientColor fg aqua0 bg2;
      focusedInactive = unfocused;
      placeholder = unfocused;
      unfocused = mkClientColor fg2 bg1 bg1;
      urgent = mkClientColor fg red0 red0;
    };

    bars = [{
      fonts = cfg.config.fonts;

      extraConfig = ''
        tray_output primary
        tray_padding 2
        separator_symbol "|"
      '';

      statusCommand = "~/src/bar/bar"; #while date +'%Y-%m-%d %l:%M:%S %p '; do sleep 1; done";

      colors = with colors.dark; rec {
        background = bg;
        separator = bg2;
        statusline = fg;

        activeWorkspace = focusedWorkspace;
        bindingMode = mkBarColor fg yellow0;
        focusedWorkspace = mkBarColor fg bg2;
        inactiveWorkspace = mkBarColor fg2 bg1;
        urgentWorkspace = mkBarColor fg red0;
      };
    }];
  };

  mkClientColor = text: indicator: c: {
    inherit text indicator;
    border = c;
    childBorder = c;
    background = c;
  };

  mkBarColor = text: c: {
    inherit text;
    border = c;
    background = c;
  };

  mkConfig = { sway ? { }, packages ? [ ], config ? { } }:
    mkIf cfg.enable (mkMerge [
      config
      {
        wayland.windowManager.sway.config = sway;
        home.packages = packages;
      }
    ]);

  mkKitty = { command, kittyArgs ? "", cmdArgs ? "" }:
    pkgs.writeShellScriptBin "kitty-${command}" ''
      exec kitty --single-instance --class "kitty-${command}" ${kittyArgs} -- \
        "${command}" ${cmdArgs}
    '';
in
mkMerge [
  (mkConfig {
    sway = swayConfig;
  })

  # terminal
  (mkConfig {
    sway = {
      terminal = "kitty";
      keybindings = mkOptionDefault {
        "Mod4+Return" = "exec kitty --single-instance";
      };
    };
    config.programs.kitty = {
      keybindings = {
        "super+shift+enter" = "new_os_window_with_cwd";
      };
    };
    packages = [ pkgs.kitty ];
  })

  # multimedia control
  (mkConfig {
    sway = {
      keybindings = mkOptionDefault {
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPrev" = "exec playerctl previous";
      };
    };
    packages = [ pkgs.playerctl ];
  })

  # screenshots
  (mkConfig {
    sway = {
      keybindings = mkOptionDefault {
        "Print" = "exec grimshot copy area";
        "Shift+Print" = "exec grimshot save area";
      };
    };
    packages = [ pkgs.sway-contrib.grimshot ];
  })

  # volume controls
  (mkConfig {
    sway = {
      keybindings = mkOptionDefault {
        "XF86AudioLowerVolume" = "exec pulsemixer --change-volume -5";
        "XF86AudioMute" = "exec pulsemixer --toggle-mute";
        "XF86AudioRaiseVolume" = "exec pulsemixer --change-volume +5";

        "Mod4+XF86AudioLowerVolume" = "exec kitty-pulsemixer";
        "Mod4+XF86AudioMute" = "exec kitty-pulsemixer";
        "Mod4+XF86AudioRaiseVolume" = "exec kitty-pulsemixer";
      };
      window.commands = [{
        criteria = { app_id = "kitty-pulsemixer"; };
        command = "border pixel 2; floating enable; sticky enable";
      }];
    };
    packages = [
      pkgs.pulsemixer
      (mkKitty {
        command = "pulsemixer";
        kittyArgs = "--override initial_window_width=800 --override initial_window_height=200";
      })
    ];
  })

  # spotify tui window
  (mkConfig {
    sway = {
      keybindings = mkOptionDefault {
        "Mod4+XF86AudioPlay" =
          "exec sh -c 'swaymsg [app_id=\"kitty-spt\"] scratchpad show || kitty-spt'";
      };
      window.commands = [{
        criteria = { app_id = "kitty-spt"; };
        command = "border pixel 2; move scratchpad; [app_id=\"kitty-spt\"] scratchpad show";
      }];
    };
    packages = [
      pkgs.spotify-tui
      (mkKitty { command = "spt"; })
    ];
  })

  (mkConfig {
    sway = {
      window.commands = [
        {
          criteria = { class = "Signal"; };
          command = "border pixel 2; move scratchpad; [class=\"Signal\"] scratchpad show";
        }
        {
          criteria = { class = "discord"; };
          command = "border pixel 2; move scratchpad; [class=\"discord\"] scratchpad show";
        }
      ];
    };
  })

  (mkConfig {
    sway = {
      keybindings = mkOptionDefault {
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };
    };
    packages = [ pkgs.brightnessctl ];
  })

  (mkConfig {
    sway = {
      keybindings = mkOptionDefault {
        "Mod4+p" = "exec 1password";
      };
      window.commands = [
        {
          criteria = { class = "1Password"; };
          command = "floating enable; sticky enable";
        }
        {
          criteria = { app_id = "1Password"; };
          command = "floating enable; sticky enable";
        }
      ];
    };
    packages = [ pkgs._1password-gui ];
  })

  (mkConfig {
    sway = {
      startup = [{
        command = ''
          sleep 1; pkill wlsunset; \
          exec wlsunset -t 3000 -T 5000 -l 52.1 -L -106.4
        '';
        always = true;
      }];
    };
    packages = [ pkgs.wlsunset ];
  })

  (mkConfig {
    sway = {
      startup = [{
        command = ''
          sleep 1; pkill swayidle; \
          exec swayidle -w \
            idlehint 1800 \
                     lock screen-lock \
                   unlock screen-unlock \
             before-sleep screen-lock \
             timeout  300 screen-lock \
             timeout 3600 screen-off resume screen-on
        '';
        always = true;
      }];
    };

    packages = with pkgs; [
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

    config.xdg.configFile = {
      "swaylock/config" = {
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
    };
  })

  (mkIf nixosConfig.programs.sway.enable {
    wayland.windowManager.sway.package = null;
  })
]
