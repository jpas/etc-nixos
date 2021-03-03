{ config, lib, pkgs, ... }:

with lib;

mkMerge [
  {
    # Intel Ivy Lake processor
    hardware.cpu.intel.updateMicrocode =
      config.hardware.enableRedistributableFirmware;

    hardware.opengl.extraPackages = with pkgs; [
      intel-compute-runtime # OpenCL support
      intel-media-driver # hardware video acceleration
    ];

    services.xserver = {
      # Use modesetting since intel is outdated and not recommended.
      # See: https://nixos.org/manual/nixos/stable/index.html#sec-x11--graphics-cards-intel
      videoDrivers = mkDefault [ "modesetting" ];

      # The modesetting driver supports "Glamor" which accelerates 2D graphics
      # using OpenGL.
      useGlamor = true;
    };
  }
  {
    # XPS 9300 specific tweaks

    # Enable fan sensors via smm
    boot.initrd.kernelModules = mkDefault [ "dell_smm_hwmon" ];
    boot.extraModprobeConfig = ''
      options dell-smm-hwmon ignore_dmi=1
    '';

    # Disbale i2c_hid touchpad, since it makes tons of IRQ/s when touchpad is
    # used, draining battery and wasting cycles as it is unused.
    boot.blacklistedKernelModules = [ "i2c_hid" ];

    # This can be removed when the default kernel is at at least version 5.7.
    # On versions older, WiFi will not work.
    boot.kernelPackages = mkIf (versionOlder pkgs.linux.version "5.6")
      (mkDefault pkgs.linuxPackages_latest);

    # Enable touchpad support
    services.xserver.libinput.enable = mkDefault true;

    # Enable trim service for SSD
    services.fstrim.enable = mkDefault true;

    # Enable firmware update daemon.
    services.fwupd.enable = mkDefault true;

    # Thermal management for laptops.
    services.tlp.enable = mkDefault true;
    services.thermald.enable = mkDefault true;

    environment.systemPackages = [
      pkgs.libsmbios # For interacting with Dell BIOS/UEFI
    ];
  }
]
