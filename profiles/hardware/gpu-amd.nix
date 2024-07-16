{ lib, config, pkgs, ... }:

with lib;

{
  imports = [ ./gpu.nix ];

  environment.systemPackages = attrValues {
    inherit (pkgs)
      radeontop
      ;
  };

  hardware.graphics.extraPackages = attrValues {
    inherit (pkgs)
      rocm-opencl-icd
      ;
  };
}
