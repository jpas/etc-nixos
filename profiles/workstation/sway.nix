{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.sway;

  sessionVariables = concatStringsSep " " [
    "DISPLAY"
    "I3SOCK"
    "SWAYSOCK"
    "WAYLAND_DISPLAY"
    "XDG_CURRENT_DESKTOP"
    "XDG_SESSION_DESKTOP"
    "XDG_SESSION_TYPE"
  ];

  sway-utils = pkgs.symlinkJoin {
    name = "sway-utils";
    paths = mapAttrsToList pkgs.writeShellScriptBin {
      sway-launch = ''
        if systemctl --user --quiet is-active sway-session.target; then
          echo "sway is already running, refusing to start." 1>&2
          exit 1
        fi
        exec systemd-cat --identifier=sway sway "$@"
      '';
      sway-logout = ''
        systemctl --user start sway-session-shutdown.target
      '';
    };
  };

  sway-lock = pkgs.writeShellScript "sway-lock" ''
    lock="$XDG_RUNTIME_DIR/swaylock-$XDG_SESSION_ID.lock"
    exec ${pkgs.util-linux}/bin/flock --nonblock --no-fork "$lock" \
      ${pkgs.swaylock}/bin/swaylock -f -C ${swaylockConfig}
  '';

  sway-unlock = pkgs.writeShellScript "sway-unlock" ''
    lock="$XDG_RUNTIME_DIR/swaylock-$XDG_SESSION_ID.lock"
    ${pkgs.psmisc}/bin/fuser --kill "$lock"
  '';

  swayidleConfig = pkgs.writeText "swayidle-config" ''
    lock         ${sway-lock}
    unlock       ${sway-unlock}

    before-sleep ${sway-lock}
    after-resume "swaymsg output '*' dpms on"

    timeout  300 ${sway-lock}
    timeout  450 "swaymsg output '*' dpms off" resume "swaymsg output '*' dpms on"
    idlehint 600
  '';

  swaylockConfig =
    let
      fmt = n: v: if isBool v then n else "${n}=${toString v}";

      genColors = prefix: value: genAttrs
        (map (s: "${prefix}${s}-color") [ "" "-clear" "-caps-lock" "-ver" "-wrong" ])
        (n: value);

      cfg = with config.hole.colours; ({
        font = "monospace";
        font-size = 10;
        text-color = fg;
        color = bg;
      }
      // (genColors "inside" "00000000")
      // (genColors "text" "00000000")
      // (genColors "line" bg)
      // {
        key-hl-color = fg;
        caps-lock-key-hl-color = neutral.yellow;

        bs-hl-color = neutral.yellow;
        caps-lock-bs-hl-color = neutral.yellow;

        ring-color = bg;
        ring-caps-lock-color = bg;

        ring-clear-color = neutral.yellow;
        ring-ver-color = neutral.blue;
        ring-wrong-color = neutral.red;
      });
    in
    pkgs.writeText "swaylock-config"
      (concatStringsSep "\n" (mapAttrsToList fmt cfg));
in
mkIf cfg.enable {
  services.greetd = {
    enable = mkDefault true;
    vt = 2;
    settings = {
      default_session = {
        command = "${config.services.greetd.package}/bin/agreety --cmd sway-launch";
      };
    };
  };

  programs.sway = {
    wrapperFeatures = {
      base = mkDefault true;
      gtk = mkDefault true;
    };

    extraSessionCommands = ''
      export XDG_SESSION_DESKTOP=sway

      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1

      export SDL_VIDEODRIVER=wayland
    '';

    extraPackages = attrValues {
      inherit sway-utils;
      inherit (pkgs)
        grim
        kanshi
        slurp
        wl-clipboard
        ;
    };
  };

  environment.etc."sway/config.d/nixos.conf".enable = mkForce false;
  environment.etc."sway/config.d/10-session.conf".text = ''
    exec_always ${pkgs.writeShellScript "sway-session" ''
      if ! systemctl --user --quiet is-active sway-session.target; then
        dbus-update-activation-environment --systemd ${sessionVariables}
        systemctl --user import-environment ${sessionVariables}
      fi
      systemctl --user reset-failed
      systemctl --user start sway-session.target
    ''}
  '';

  systemd.user.targets = {
    sway-session = {
      bindsTo = [ "graphical-session.target" ];
      before = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    sway-session-shutdown = {
      conflicts = [ "graphical-session.target" "graphical-session-pre.target" "sway-session.target" ];
      after = [ "graphical-session.target" "graphical-session-pre.target" "sway-session.target" ];
      unitConfig = {
        StopWhenUnneeded = "yes";
      };
    };
  };

  systemd.user.services = {
    swayidle = {
      wantedBy = [ "sway-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.swayidle}/bin/swayidle -w -C ${swayidleConfig}";
        Slice = "session.slice";
      };
    };

    sway-session-unset-environment = {
      wantedBy = [ "sway-session-shutdown.target" ];
      after = [ "sway-session-exit.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "systemctl --user unset-environment ${sessionVariables}";
      };
      unitConfig = {
        RefuseManualStart = true;
        RefuseManualStop = true;
      };
    };

    sway-session-exit = {
      wantedBy = [ "sway-session-shutdown.target" ];
      script = ''
        ${pkgs.sway}/bin/swaymsg exit || true
      '';
      serviceConfig.Type = "oneshot";
      unitConfig = {
        RefuseManualStart = true;
        RefuseManualStop = true;
      };
    };
  };

  xdg.portal.wlr.enable = mkDefault true;
  #xdg.portal.wlr.settings.screencast = {
  #  chooser_type = mkDefault "simple";
  #  chooser_cmd = mkDefault (with config.hole.colours; concatStringsSep " " [
  #    "${pkgs.slurp}/bin/slurp -or"
  #    "-f %o"
  #    "-b ${bg}00"
  #    "-c ${normal.aqua}ff"
  #    "-s ${normal.aqua}7f"
  #    "-B ${bg}00"
  #    "-w 2"
  #  ]);
  #};
  systemd.user.services = {
    xdg-desktop-portal-wlr = {
      serviceConfig.Slice = "session.slice";
    };
  };
}
