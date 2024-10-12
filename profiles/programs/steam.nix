{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.steam;
in
{
  programs.steam.enable = true;

  hardware.steam-hardware.enable = mkDefault cfg.enable;
  programs.steam.remotePlay.openFirewall = mkDefault cfg.enable;

  environment.systemPackages = mkIf cfg.enable [
    pkgs.steam-run
    pkgs.protontricks
  ];

  programs.sway.include."50-steam.conf" = mkIf cfg.enable ''
    for_window [class="Steam"] floating enable, border none
    for_window [class="streaming_client"] floating enable, border pixel
    for_window [class="steam_proton"] floating enable, border pixel
    for_window [class="explorer.exe"] floating enable, border pixel
    for_window [class="steam_app_[0123456789]+"] border none, inhibit_idle open
  '';
}
