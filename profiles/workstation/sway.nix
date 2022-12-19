{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.sway;

  sway-launch = pkgs.writeShellScriptBin "sway-launch" ''
    exec systemd-cat --identifier=sway sway "$@"
  '';
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
      export SDL_VIDEODRIVER=wayland

      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    extraPackages = attrValues {
      inherit sway-launch;
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
  environment.etc."sway/config.d/10-systemd.conf".text = ''
    exec_always "${concatStringsSep "; " [
      "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
      "systemctl --user start sway-session.target"
    ]}"
  '';

  systemd.user.targets."sway-session" = {
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  xdg.portal.enable = mkDefault true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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
