{ ... }:
{
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
}
