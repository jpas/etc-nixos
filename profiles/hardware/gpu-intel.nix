{ lib, pkgs, ... }:

with lib;

{
  imports = [ ./gpu.nix ];

  hardware.opengl.extraPackages = attrValues {
    inherit (pkgs)
      intel-compute-runtime
      intel-media-driver
      vaapiIntel
      ;
  };

  hardware.opengl.extraPackages32 = attrValues {
    inherit (pkgs.pkgsi686Linux)
      vaapiIntel
      ;
  };
}
