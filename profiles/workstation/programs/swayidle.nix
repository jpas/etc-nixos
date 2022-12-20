{ lib, config, pkgs, ... }:

with lib;

{
  environment.systemPackages = [ pkgs.swayidle pkgs.swaylock ];

  environment.etc."swayidle/config".text = ''
    lock         "swaylock -f"
    unlock       "pkill --uid $UID --signal SIGUSR1 swaylock"

    before-sleep "swaylock -f"
    after-resume "swaymsg output '*' dpms on"

    timeout   10 "swaylock -f"
    timeout   15 "swaymsg output '*' dpms off" resume "swaymsg output '*' dpms on"
    idlehint 600
  '';

  systemd.user.services.swayidle = {
    wantedBy = [ "sway-session.target" ];
    after = [ "sway-session.target" ];
    path = [ pkgs.sway pkgs.swayidle pkgs.swaylock pkgs.procps ];
    serviceConfig = {
      ExecStart = "swayidle -w";
      Type = "simple";
      Slice = "session.slice";
    };
  };
}
