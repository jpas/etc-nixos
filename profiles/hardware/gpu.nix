{ lib, config, pkgs, ... }:

with lib;

{
  hardware.graphics.extraPackages = attrValues {
    inherit (pkgs)
      libva
      libva-vdpau-driver
      libvdpau-va-gl
      ;
  };

  hardware.graphics.enable32Bit = mkDefault cfg.hardware.graphics.enable;
  hardware.graphics.extraPackages32 = attrValues {
    inherit (pkgs.pkgsi686Linux)
      libva
      libva-vdpau-driver
      libvdpau-va-gl
      ;
  };
}
