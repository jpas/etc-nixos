{ lib
, config
, pkgs
, ...
}:

with lib;

{
  boot.kernelModules = [ "kvm-intel" ];

  hardware.cpu.intel.updateMicrocode =
    mkDefault config.hardware.enableRedistributableFirmware;
}
