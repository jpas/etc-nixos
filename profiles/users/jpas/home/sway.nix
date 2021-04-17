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

    floating.titlebar = true;
    window.titlebar = true;

    input."type:keyboard" = {
      xkb_options = "caps:escape";
    };

    output."*".bg = "~/.config/sway/bg.png fill";

    window.commands = [
      {
        criteria = { app_id = "menu"; };
        command = "floating enable; sticky enable; border pixel 2";
      }
      {
        criteria = { class = "explorer.exe"; };
        command = "floating enable; border pixel 2";
      }
    ];

    keybindings = let inherit (cfg.config) modifier; in mkOptionDefault {
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
      focused = mkClientColor fg aqua1 bg2;
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

  mkConfig = { sway ? {}, packages ? [], config ? {} }:
    mkIf cfg.enable (mkMerge [
      config
      {
        wayland.windowManager.sway.config = sway;
        home.packages = packages;
      }
    ]);

  mkKitty = { command, kittyArgs ? "", cmdArgs ? "" }:
    pkgs.writeShellScriptBin "kitty-${command}" ''
      exec kitty --single-instance --class "kitty-${command}" ${kittyArgs} -- "${command}" ${cmdArgs}
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

  (mkIf nixosConfig.programs.sway.enable {
    wayland.windowManager.sway.package = null;
  })
]
