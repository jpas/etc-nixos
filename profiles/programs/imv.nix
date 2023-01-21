{ lib, config, pkgs, ... }:

let
  colours = config.hole.colours;
in
{
  environment.systemPackages = [ pkgs.imv ];

  environment.etc."imv_config".text = with colours; ''
    [options]
    overlay_font = "monospace:10"
    background=${bg}
    overlay_background_color=${bg1}
    overlay_background_alpha=ff
    overlay_text_color=${bg1}
    overlay_text_alpha=ff
  '';

  programs.sway.include."50-imv.conf" = ''
    for_window [app_id="imv"] floating enable, border normal
  '';
}
