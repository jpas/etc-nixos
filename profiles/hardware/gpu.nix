{ lib, config, pkgs, ... }:

with lib;

{
  hardware.opengl.driSupport = mkDefault true;
  hardware.opengl.extraPackages = attrValues {
    inherit (pkgs)
      libva
      libvdpau-va-gl
      vaapiVdpau
      ;
  };

  hardware.opengl.driSupport32Bit = mkDefault config.hardware.opengl.driSupport;
  hardware.opengl.extraPackages32 = attrValues {
    inherit (pkgs.pkgsi686Linux)
      libva
      libvdpau-va-gl
      vaapiVdpau
      ;
  };
}
