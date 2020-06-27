{ pkgs, ... }: {
  imports = [
    <nixos-hardware/dell/xps/13-9300> # TODO: upstream...
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = [
    pkgs.libsmbios # For Dell BIOS/UEFI
  ];

  # Enable touchpad support
  services.xserver.libinput.enable = true;

  # Enable firmware update daemon.
  services.fwupd.enable = true;

  # System specific tweaks...
  # https://wiki.archlinux.org/index.php/Dell_XPS_13_(9300)

  # Override the built in conservative power profile.
  services.throttled.enable = true;

  # Thermal management for laptops.
  services.tlp.enable = true;
  services.thermald.enable = true;

  # WiFi drivers do not work on Linux < 5.7
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_5_7;
}
