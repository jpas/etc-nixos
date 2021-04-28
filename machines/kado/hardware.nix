{ ... }:
{
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems =
    let
      onAleph = subvol: {
        device = "/dev/disk/by-uuid/8aebe979-4cbd-45c6-a83e-44a165be7226";
        fsType = "btrfs";
        options = [ "subvol=${subvol}" "space_cache=v2" "autodefrag" "relatime" ];
      };
    in
    {
      "/" = {
        device = "/dev/disk/by-uuid/7932c7d2-49c2-453b-a406-4a73509a57fd";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/E914-BBE6";
        fsType = "vfat";
      };

      "/aleph/home" = onAleph "/home";
      "/aleph/media" = onAleph "/media";
      "/srv/exports/aleph/home" = {
        device = "/aleph/home";
        options = [ "bind" ];
      };
      "/srv/exports/aleph/media" = {
        device = "/aleph/media";
        options = [ "bind" ];
      };
    };

  swapDevices = [
    { device = "/dev/disk/by-uuid/f1476467-c295-47c7-8d0b-51dbcaf182dd"; }
  ];
}
