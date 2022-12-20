{ lib
, flake
, config
, nixosConfig
, pkgs
, ...
}:

with lib;

let
  cfg = config.wayland.windowManager.sway;

  colours = nixosConfig.hole.colours.fmt (c: "#${c}");

  swayConfig = {
    fonts = {
      names = [ "monospace" ];
      size = 10.0;
    };

    modifier = "Mod4";
    workspaceAutoBackAndForth = true;

    input = {
      #"type:keyboard" = {
      #  xkb_options = "caps:escape";
      #};
      "type:touchpad" = {
        tap = "enabled";
      };
    };

    output."*".bg = "${./bg.png} fill";

    floating.titlebar = true;

    seat."*".xcursor_theme = "Adwaita";

    window.titlebar = true;
    window.commands = [
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

        "${modifier}+d" = ''
          exec "tofi-run | xargs swaymsg exec --"
        '';

        # TODO
        #"${modifier}+o" = ''
        #  exec ${menu} \
        #    menu-pdfs \
        #    "xargs -r swaymsg -t command exec zathura --" \
        #    "--delimiter / --with-nth -1"
        #'';
      };

    colors = with colours; rec {
      background = bg;
      focused = mkClientColor fg neutral.aqua bg2;
      focusedInactive = unfocused;
      placeholder = unfocused;
      unfocused = mkClientColor fg2 bg1 bg1;
      urgent = mkClientColor fg neutral.red neutral.red;
    };

    bars = [{
      fonts = cfg.config.fonts;

      extraConfig = ''
        tray_output primary
        tray_padding 2
        separator_symbol "|"
      '';

      statusCommand = "${pkgs.writeShellScript "sway-status" ''
          status() {
            date '+%m-%d %H:%M'
          }

          while status; do
            sleep 1;
          done
        ''}";

      colors = with colours; rec {
        background = bg;
        separator = gray;
        statusline = fg;

        activeWorkspace = focusedWorkspace;
        bindingMode = mkBarColor bg0 neutral.yellow;
        focusedWorkspace = mkBarColor fg bg2;
        inactiveWorkspace = mkBarColor fg2 bg1;
        urgentWorkspace = mkBarColor fg neutral.red;
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
    config.wayland.windowManager.sway.extraConfig = mkAfter ''
      focus_on_window_activation none
      include /etc/sway/config.d/*
      include config.d/*
    '';
  })

  (mkConfig {
    sway.startup = [{
      command = "busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 5000";
      always = true;
    }];
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
        "Print" = "exec ${run-unique} screenshot grimshot copy area";
        "Shift+Print" = "exec ${run-unique} screenshot grimshot save area";
      };
    };
    packages = [ pkgs.sway-contrib.grimshot ];
  })

  # volume controls
  (mkConfig {
    sway = {
      keybindings = mkOptionDefault {
        "XF86AudioMute" = "exec pulsemixer --toggle-mute";
        "XF86AudioLowerVolume" = "exec pulsemixer --change-volume -1";
        "Shift+XF86AudioLowerVolume" = "exec pulsemixer --change-volume -5";
        "XF86AudioRaiseVolume" = "exec pulsemixer --change-volume +1";
        "Shift+XF86AudioRaiseVolume" = "exec pulsemixer --change-volume +5";

        "Mod4+XF86AudioLowerVolume" = "exec kitty-pulsemixer";
        "Mod4+XF86AudioMute" = "exec kitty-pulsemixer";
        "Mod4+XF86AudioRaiseVolume" = "exec kitty-pulsemixer";
      };
      window.commands = [{
        criteria = { app_id = "kitty-pulsemixer"; };
        command = "border pixel, floating enable, sticky enable, resize set 800 200";
      }];
    };
    packages = [
      pkgs.pulsemixer
      (mkKitty { command = "pulsemixer"; })
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
        command = "border pixel, move scratchpad, resize set 800 400, scratchpad show";
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
          criteria = { app_id = "Signal|discord"; };
          command = "border pixel, move scratchpad, scratchpad show";
        }
        {
          criteria = { class = "Signal|discord"; };
          command = "border pixel, move scratchpad, scratchpad show";
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

  # (mkConfig {
  #   sway = {
  #     keybindings = mkOptionDefault {
  #       "Mod4+p" = "exec 1password";
  #     };
  #     window.commands = [
  #       {
  #         criteria = { class = "1Password"; };
  #         command = "floating enable, sticky enable";
  #       }
  #       {
  #         criteria = { app_id = "1Password"; };
  #         command = "floating enable, sticky enable";
  #       }
  #     ];
  #   };
  #   packages = [ pkgs._1password-gui ];
  # })

  # TODO: only enable if needed
  (mkSessionConfig {
    name = "kanshi";
    script = "exec kanshi";
  })

  (mkIf nixosConfig.programs.sway.enable {
    wayland.windowManager.sway.enable = true;
    wayland.windowManager.sway.package = null;
  })
]
