{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.steam;
in
{
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.enable = true;

  environment.systemPackages = [ pkgs.steam-run ];

  programs.sway.include."50-steam.conf" = ''
    for_window [class="Steam"] floating enable, border none
    for_window [class="streaming_client"] floating enable, border pixel
    for_window [class="steam_proton"] floating enable, border pixel
    for_window [class="explorer.exe"] floating enable, border pixel
  '';
}
