{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./dell-smm-hwmon.nix
    ./thermald
    ./intel.nix
  ];

  environment.systemPackages = [
    pkgs.libsmbios # For Dell BIOS/UEFI
  ];

  # Enable touchpad support
  services.xserver.libinput.enable = lib.mkDefault true;

  # Disbale i2c_hid touchpad, since it makes tons of IRQ/s...
  boot.blacklistedKernelModules = [ "i2c_hid" ];

  # Enable firmware update daemon.
  services.fwupd.enable = lib.mkDefault true;

  services.fstrim.enable = lib.mkDefault true;

  # Thermal management for laptops.
  services.tlp.enable = lib.mkDefault true;

  # This can be removed when the default kernel is at at least version 5.7.
  # On versions older, WiFi will not work.
  boot.kernelPackages = lib.mkIf
    (lib.versionOlder pkgs.linux.version "5.6")
    (lib.mkDefault pkgs.linuxPackages_latest);

  hardware.pulseaudio = {
    daemon.config = {
      avoid-resampling = lib.mkDefault true;
      #default-sample-format = lib.mkDefault "s16le";
      #default-sample-rate = lib.mkDefault "48000";
    };
  };
}
