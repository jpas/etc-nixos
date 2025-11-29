{ lib, pkgs, ... }:

with lib;

{
  imports = [ ./gpu.nix ];

  hardware.graphics.extraPackages = attrValues {
    inherit (pkgs)
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
      ;
  };

  hardware.graphics.extraPackages32 = attrValues {
    inherit (pkgs.pkgsi686Linux)
      intel-vaapi-driver
      ;
  };
}
