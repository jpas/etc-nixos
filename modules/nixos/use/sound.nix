{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hole.use;
in
{
  options = {
    hole.use.sound = mkEnableOption "sound";
  };

  config = mkIf cfg.sound (mkMerge [
    {
      services.pipewire = {
        enable = mkDefault true;

        alsa.enable = mkDefault true;
        alsa.support32Bit = mkDefault true;

        # TODO: complain if pipewire and pulseaudio are enabled
        pulse.enable = mkDefault true;

        media-session.enable = mkDefault false;
        wireplumber.enable = mkDefault true;
      };

      systemd.user.services.pipewire-pulse = {
        bindsTo = [ "pipewire.service" ];
      };
    }

    (mkIf config.services.pipewire.enable {
      security.rtkit.enable = mkDefault true;

      hardware.pulseaudio.enable = mkForce false;

      hardware.opengl = {
        extraPackages = [ pkgs.pipewire ];
        extraPackages32 = [ pkgs.pkgsi686Linux.pipewire ];
      };

      environment.systemPackages = [
        pkgs.pulseaudio # needed for pactl
        pkgs.pulsemixer
      ];
    })
  ]);
}
