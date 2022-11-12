{ lib, ... }:

with lib;

# Notes:
# fan control via ipmi
# https://github.com/missmah/ipmi_tools/blob/master/ipmi_fancontrol.pl

{
  imports = [
    ../hardware/intel-cpu.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices.crypted = {
    device = "/dev/disk/by-uuid/75b16615-d495-4fb9-9150-4febc1c6f25e";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3cc56ffc-1714-4463-9cf4-902a883eafb5";
      fsType = "btrfs";
      options = [ "relatime" "subvol=@" "compress=zstd" "space_cache=v2" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/3cc56ffc-1714-4463-9cf4-902a883eafb5";
      fsType = "btrfs";
      options = [ "noatime" "subvol=@nix" "compress=zstd" "space_cache=v2" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1874-8176";
      fsType = "vfat";
    };

  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b022d055-04e1-4ce6-ab01-6b66d47fd35a"; }
  ];
}
