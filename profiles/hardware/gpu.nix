{ lib, config, pkgs, ... }:

with lib;

{
  hardware.graphics.extraPackages = attrValues {
    inherit (pkgs)
      libva
      libvdpau-va-gl
      vaapiVdpau
      ;
  };

  hardware.graphics.enable32Bit = mkDefault cfg.hardware.graphics.enable;
  hardware.graphics.extraPackages32 = attrValues {
    inherit (pkgs.pkgsi686Linux)
      libva
      libvdpau-va-gl
      vaapiVdpau
      ;
  };
}
