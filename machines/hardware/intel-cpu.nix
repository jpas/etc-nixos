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

  # TODO: only if it is a laptop?
  services.thermald.enable = mkDefault true;
}
