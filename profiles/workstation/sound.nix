{ lib, pkgs, ... }:

with lib;

{
  hardware.pulseaudio.enable = mkForce false;
  services.pipewire.enable = mkDefault true;

  services.pipewire = {
    alsa.enable = mkDefault true;
    alsa.support32Bit = mkDefault true;

    # TODO: complain if pipewire and pulseaudio are enabled
    pulse.enable = mkDefault true;

    media-session.enable = mkDefault false;
    wireplumber.enable = mkDefault true;
  };

  systemd.user.services.pipewire-pulse = {
    bindsTo = [ "pipewire.service" ];
    after = [ "pipewire.service" ];
  };

  security.rtkit.enable = mkDefault true;

  hardware.opengl = {
    extraPackages = [ pkgs.pipewire ];
    extraPackages32 = [ pkgs.pkgsi686Linux.pipewire ];
  };

  environment.systemPackages = [
    pkgs.pulseaudio # needed for pactl
    pkgs.pulsemixer
  ];
}
