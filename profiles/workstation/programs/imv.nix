{ lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.imv ];

  programs.sway.include."50-imv.conf" = ''
    for_window [app_id="imv"] floating enable, border normal
  '';
}
