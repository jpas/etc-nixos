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
    fonts = {
      names = [ "monospace" ];
      size = 10.0;
    };

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

    seat."*".xcursor_theme = "Adwaita";

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
      { criteria = { title = "."; }; command = "inhibit_idle fullscreen"; }
      { criteria = { shell = "xwayland"; }; command = "title_format \"[xwayland] %title\""; }
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

  mkStartupScript = name: { script, always ? false }: {
    command = "${pkgs.writeShellScript name script}";
    inherit always;
  };

  run-unique = pkgs.writeShellScript "run-unique" ''
    name=$1
    shift

    lock="$XDG_RUNTIME_DIR/$name-$XDG_SESSION_ID.lock"
    touch "$lock"

    ${pkgs.psmisc}/bin/fuser --kill "$lock"
    exec 4<>"$lock"
    ${pkgs.util-linux}/bin/flock --nonblock 4 || exit 1

    exec systemd-cat -t "$name" -- "$@"
  '';

  mkSessionConfig = { name, script, packages ? [ ], config ? { } }:
    let
      start = pkgs.writeShellScript "${name}" script;
    in
    mkConfig {
      inherit packages config;
      sway.startup = [
        (mkStartupScript "${name}-session" {
          always = true;
          script = ''
            exec ${run-unique} "${name}" ${start}
          '';
        })
      ];
    };
in
mkMerge [
  (mkConfig {
    sway = swayConfig;
    config.wayland.windowManager.sway.extraConfig = ''
      focus_on_window_activation none
    '';
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

  # TODO: only enable if needed
  (mkSessionConfig {
    name = "kanshi";
    script = "exec kanshi";
  })

  (mkSessionConfig  {
    name = "wlsunset";
    script = "exec wlsunset -t 3000 -T 5000 -l 52.1 -L -106.4";
  })

  (mkSessionConfig {
    name = "swayidle";
    script = ''
      exec swayidle -w \
             idlehint 1800 \
                      lock lock-session \
                    unlock unlock-session \
              before-sleep lock-session \
              timeout  300 lock-session \
              timeout 3600 "swaymsg output '*' dpms off" \
                    resume "swaymsg output '*' dpms on"
    '';

    packages = with pkgs; [
      (writeShellScriptBin "lock-session" ''
        lock="$XDG_RUNTIME_DIR/swaylock-$XDG_SESSION_ID.lock"
        exec \
          ${pkgs.util-linux}/bin/flock --nonblock --no-fork "$lock" \
          swaylock -f
      '')
      (writeShellScriptBin "unlock-session" ''
        lock="$XDG_RUNTIME_DIR/swaylock-''${1:-$XDG_SESSION_ID}.lock"
        ${pkgs.psmisc}/bin/fuser --kill "$lock"
      '')
    ];

    config.xdg.configFile = {
      "swaylock/config" = {
        text = with colors.dark-no-hash; ''
          font=monospace
          font-size=10
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
