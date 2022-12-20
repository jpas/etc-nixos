{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.sway;

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

  sessionVariables = concatStringsSep " " [
    "DISPLAY"
    "I3SOCK"
    "SWAYSOCK"
    "WAYLAND_DISPLAY"
    "XDG_CURRENT_DESKTOP"
    "XDG_SESSION_DESKTOP"
    "XDG_SESSION_TYPE"
  ];
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
        swayidle
        swaylock
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
    sway-session-unset-environment = {
      wantedBy = [ "sway-session-shutdown.target" ];
      after = [ "sway-session-exit.service" ];
      serviceConfig = {
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
