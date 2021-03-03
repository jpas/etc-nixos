{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.networking.wireless.iwd;
in
mkIf cfg.enable {
  environment.systemPackages = [ pkgs.iw ];
}
