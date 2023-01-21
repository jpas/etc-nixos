{ lib, config, pkgs, ... }:

with lib;

let
  sessionVariables = concatStringsSep " " [
    "DISPLAY"
    "I3SOCK"
    "SWAYSOCK"
    "WAYLAND_DISPLAY"
    "XDG_CURRENT_DESKTOP"
    "XDG_SESSION_DESKTOP"
    "XDG_SESSION_TYPE"
  ];

  sway-session = pkgs.symlinkJoin {
    name = "sway-session";
    paths = mapAttrsToList pkgs.writeShellScriptBin {
      sway-login = ''
        if systemctl --user --quiet is-active sway-session.target; then
          echo "sway is already running, refusing to start." 1>&2
          exit 1
        fi
        exec systemd-cat --identifier=sway sway "$@"
      '';
      sway-logout = ''
        systemctl --user start sway-logout.target
      '';
    };
  };
in
mkIf config.programs.sway.enable {
  services.greetd = {
    enable = mkDefault true;
    vt = 2;
    settings = {
      default_session = {
        command = "${config.services.greetd.package}/bin/agreety --cmd sway-login";
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

    extraPackages = [ sway-session ];
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

  # TODO: stop session if sway exits in any way

  systemd.user.targets = {
    sway-session = {
      bindsTo = [ "graphical-session.target" ];
      before = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    sway-logout = {
      conflicts = [ "graphical-session.target" "graphical-session-pre.target" "sway-session.target" ];
      after = [ "graphical-session.target" "graphical-session-pre.target" "sway-session.target" ];
      unitConfig = {
        StopWhenUnneeded = "yes";
      };
    };
  };

  systemd.user.services = {
    sway-exit = {
      wantedBy = [ "sway-logout.target" ];
      after = [ "sway-logout.target" ];
      script = ''
        ${pkgs.sway}/bin/swaymsg exit || true
        systemctl --user unset-environment ${sessionVariables}
      '';
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig = {
        RefuseManualStart = true;
        RefuseManualStop = true;
      };
    };

    xdg-desktop-portal-wlr = {
      serviceConfig.Slice = "session.slice";
    };
  };
}
