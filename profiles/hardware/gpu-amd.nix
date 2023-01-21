{ lib, config, pkgs, ... }:

with lib;

{
  imports = [ ./gpu.nix ];

  environment.systemPackages = attrValues {
    inherit (pkgs)
      radeontop
      ;
  };

  hardware.opengl.extraPackages = attrValues {
    inherit (pkgs)
      rocm-opencl-icd
    ;
  };
}
