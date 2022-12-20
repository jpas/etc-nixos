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

      sway-session = ''
        if ! systemctl --user --quiet is-active sway-session.target; then
          dbus-update-activation-environment ${sessionVariables}
          systemctl --user import-environment ${sessionVariables}
          systemctl --user reset-failed
        fi
        systemctl --user start sway-session.target
      '';

      sway-exit = ''
        systemctl --user stop sway-session.target
        systemctl --user unset-environment ${sessionVariables}
        swaymsg exit
      '';
    };
  };
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
    exec_always ${sway-utils}/bin/sway-session
  '';

  systemd.user.targets."sway-session" = {
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
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
}
