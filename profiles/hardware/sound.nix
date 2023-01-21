{ lib, pkgs, ... }:

with lib;

{
  security.rtkit.enable = mkDefault true;

  hardware.pulseaudio.enable = mkForce false;
  services.pipewire.enable = mkDefault true;

  services.pipewire = {
    alsa.enable = mkDefault true;
    alsa.support32Bit = mkDefault true;
    pulse.enable = mkDefault true;
    media-session.enable = mkDefault false;
    wireplumber.enable = mkDefault true;
  };

  systemd.user.services.pipewire-pulse = {
    bindsTo = [ "pipewire.service" ];
    after = [ "pipewire.service" ];
  };

  hardware.opengl = {
    extraPackages = [ pkgs.pipewire ];
    extraPackages32 = [ pkgs.pkgsi686Linux.pipewire ];
  };

  programs.sway.extraPackages = attrValues {
    inherit (pkgs) pulsemixer;
  };
}
