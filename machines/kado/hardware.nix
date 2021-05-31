{ ... }:
{
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7932c7d2-49c2-453b-a406-4a73509a57fd";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/E914-BBE6";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/f1476467-c295-47c7-8d0b-51dbcaf182dd"; }
  ];
}
