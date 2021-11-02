{ lib
, config
, pkgs
, ...
}:

with lib;

{
  boot.kernelParams = [ "intel_pstate=active" ];
  boot.kernelModules = [ "kvm-intel" ];

  hardware.cpu.intel.updateMicrocode =
    mkDefault config.hardware.enableRedistributableFirmware;
}
