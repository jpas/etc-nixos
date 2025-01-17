{ lib, pkgs, ... }:

with lib;

{
  security.rtkit.enable = mkDefault true;

  services.pipewire.enable = mkDefault true;

  services.pipewire = {
    alsa.enable = mkDefault true;
    alsa.support32Bit = mkDefault true;
    pulse.enable = mkDefault true;
    wireplumber.enable = mkDefault true;
  };

  systemd.user.services.pipewire-pulse = {
    bindsTo = [ "pipewire.service" ];
    after = [ "pipewire.service" ];
  };

  hardware.graphics = {
    extraPackages = [ pkgs.pipewire ];
    extraPackages32 = [ pkgs.pkgsi686Linux.pipewire ];
  };

  programs.sway.extraPackages = attrValues {
    inherit (pkgs) pulsemixer;
  };
}
