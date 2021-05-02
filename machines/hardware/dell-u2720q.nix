{ config
, pkgs
, ...
}:

{
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];

  boot.kernelModules = [ "i2c_dev" "ddcci" "ddcci-backlight" ];

  environment.systemPackages = [ pkgs.ddcutil ];
}
