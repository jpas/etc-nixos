{ lib, config, pkgs, ... }:

with lib;

{
  environment.systemPackages = [ pkgs.swayidle pkgs.swaylock ];

  environment.etc."xdg/swayidle/config".text = ''
    lock         "swaylock -f"
    unlock       "pkill --uid $UID --signal SIGUSR1 swaylock"

    before-sleep "swaylock -f"
    after-resume "swaymsg output '*' dpms on"

    timeout  300 "swaylock -f"
    timeout  450 "swaymsg output '*' dpms off" resume "swaymsg output '*' dpms on"
    idlehint 600
  '';

  systemd.user.services.swayidle = {
    wantedBy = [ "sway-session.target" ];
    after = [ "sway-session.target" ];
    path = [ pkgs.sway pkgs.swaylock pkgs.procps ];
    serviceConfig = {
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w";
      Type = "simple";
      Slice = "session.slice";
    };
  };
}
