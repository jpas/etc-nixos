{ config
, ...
}:

{
  services.colord.enable = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];

  boot.kernelModules = [ "i2c_dev" "ddcci" "ddcci-backlight" ];
}
