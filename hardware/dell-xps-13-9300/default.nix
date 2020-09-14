{ lib, pkgs, ... }: {
  imports = [
    <nixos-hardware/dell/xps/13-9300> # TODO: upstream...
  ];

  environment.systemPackages = [
    pkgs.libsmbios # For Dell BIOS/UEFI
  ];

  # Enable touchpad support
  services.xserver.libinput.enable = lib.mkDefault true;

  # Enable firmware update daemon.
  services.fwupd.enable = lib.mkDefault true;

  # Use only Intel driver for X11
  services.xserver.videoDrivers = lib.mkDefault [ "intel" ];

  # System specific tweaks...
  # https://wiki.archlinux.org/index.php/Dell_XPS_13_(9300)

  # Override the built in conservative power profile.
  services.throttled.enable = lib.mkDefault true;

  # Thermal management for laptops.
  services.tlp.enable = lib.mkDefault true;
  services.thermald.enable = lib.mkDefault true;

  # WiFi drivers do not work on Linux < 5.7, this should be at least that.
  boot.kernelPackages = lib.mkDefault (pkgs.linuxPackagesFor pkgs.linux_latest);
}
