{ lib, pkgs, ... }: {
  # Define your hostname.
  networking.hostName = "kuro";

  boot.supportedFilesystems = [ "ntfs" ];

  imports = [
    ../../hardware/dell-xps-13-9300
    ../../hardware/logitech-mx-master-3.nix

    ../../profiles/graphical.nix

    ../../services/systemd-boot.nix
    ../../services/games

    ../../users/jpas
  ];

  # Enable documentation for development
  documentation.dev.enable = true;

  # Undervolting to improve battery life and temperatures.
  services.throttled.enable = true;
  # *** WARNING *** these were tweaked specifically for my machine, using them
  # on your own machine may result in instability
  services.throttled.extraConfig = builtins.readFile ./throttled.conf;

  # Disable thermald since it may get in the way of throttled
  services.thermald.enable = false;

  # Enable fan monitoring
  boot.initrd.kernelModules = [
    "dell_smm_hwmon"
  ];

  boot.extraModprobeConfig = ''
    options dell-smm-hwmon ignore_dmi=1
  '';
}
