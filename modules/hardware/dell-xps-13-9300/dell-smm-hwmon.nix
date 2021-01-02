{ lib, ... }:
{
  boot.initrd.kernelModules = lib.mkDefault [
    "dell_smm_hwmon"
  ];

  boot.extraModprobeConfig = ''
    options dell-smm-hwmon ignore_dmi=1
  '';
}
