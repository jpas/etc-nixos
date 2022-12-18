{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.steam;
in
mkIf cfg.enable {
  environment.systemPackages = [ pkgs.steam-run ];

  programs.steam.remotePlay.openFirewall = true;

  environment.etc."sway/config.d/steam.conf".text = ''
    for_window [class="Steam"] floating enable, border none
    for_window [class="streaming_client"] floating enable, border pixel
    for_window [class="steam_proton"] floating enable, border pixel
    for_window [class="explorer.exe"] floating enable, border pixel
  '';
}
