{ lib
, config
, pkgs
, ...
}:

with lib;

{
  imports = [
    ./bluetooth.nix
    ./intel-cpu.nix
    ./intel-gpu.nix
    ./laptop.nix
    ./wifi.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "rtsx_pci_sdmmc" ];

  boot.kernelPatches = [
    {
      name = "enable-platform-drivers-dell";
      patch = null;
      extraConfig = ''
        X86_PLATFORM_DRIVERS_DELL y
      '';
    }
  ];

  # Disables i2c_hid because it makes tons of IRQ/s when touchpad is used,
  # draining battery and wasting cycles as it is unused.
  boot.blacklistedKernelModules = [ "i2c_hid" ];

  # Enable fan sensors via smm
  boot.kernelModules = [ "dell_smm_hwmon" ];
  boot.extraModprobeConfig = ''
    options dell-smm-hwmon ignore_dmi=1
  '';

  powerManagement.cpuFreqGovernor = "powersave";

  # Needed for wifi and bluetooth to work
  hardware.enableRedistributableFirmware = mkDefault true;

  hardware.video.hidpi.enable = mkDefault true;

  services.fwupd.enable = mkDefault true;

  services.hardware.bolt.enable = mkDefault true;

  services.pipewire.config.pipewire-pulse = {
    context.modules = {
      # TODO: see https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/master/src/modules/module-protocol-pulse/modules/module-echo-cancel.c
    };
  };

  environment.systemPackages = [
    pkgs.libsmbios # For interacting with Dell BIOS/UEFI
  ];
}
