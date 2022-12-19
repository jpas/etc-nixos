{ lib, pkgs, ... }:

with lib;

{
  programs.sway.extraPackages = [ pkgs.wl-gammarelay-rs ];

  systemd.user.services.wl-gammarelay-rs = {
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "sway-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs";
      ExecStartPost = "busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 5000";
    };
  };
}
