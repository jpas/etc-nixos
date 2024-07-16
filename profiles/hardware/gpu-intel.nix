{ lib, pkgs, ... }:

with lib;

{
  imports = [ ./gpu.nix ];

  hardware.graphics.extraPackages = attrValues {
    inherit (pkgs)
      intel-compute-runtime
      intel-media-driver
      vaapiIntel
      ;
  };

  hardware.graphics.extraPackages32 = attrValues {
    inherit (pkgs.pkgsi686Linux)
      vaapiIntel
      ;
  };
}
