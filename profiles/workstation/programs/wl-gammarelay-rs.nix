{ lib, pkgs, ... }:

with lib;

let
  package = pkgs.wl-gammarelay-rs;

  dbus-service = pkgs.writeTextDir "share/dbus-1/services/rs.wl-gammarelay.service" ''
    [D-BUS Service]
    Name=rs.wl-gammarelay
    Exec=${package}/bin/wl-gammarelay-rs
    SystemdService=wl-gammarelay-rs.service
  '';
in
{
  environment.systemPackages = [ package ];
  services.dbus.packages = [ dbus-service ];

  systemd.user.services.wl-gammarelay-rs = {
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "dbus";
      BusName = "rs.wl-gammarelay";
      ExecStart = "${package}/bin/wl-gammarelay-rs";
      Slice = "session.slice";
    };

    unitConfig = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
  };
}
