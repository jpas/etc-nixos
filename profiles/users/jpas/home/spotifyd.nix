{ lib
, config
, nixosConfig
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.spotifyd;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
      spotify-tui
    ];

    services.spotifyd = {
      package = pkgs.spotifyd.override {
        withPulseAudio = true;
        withMpris = true;
      };
      settings = {
        global = {
          username_cmd = "cat ~/.config/spotifyd/username";
          password_cmd = "cat ~/.config/spotifyd/password";
          backend = "pulseaudio";
          use_mpris = true;
          bitrate = 320;
          device_name = nixosConfig.networking.hostName;
          device_type = "computer";
        };
      };
    };
  };
}
