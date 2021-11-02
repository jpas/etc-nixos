{ lib
, config
, pkgs
, ...
}:

with lib;

{
  boot.kernelModules = [ "kvm-intel" "intel_pstate=active" ];

  hardware.cpu.intel.updateMicrocode =
    mkDefault config.hardware.enableRedistributableFirmware;
}
