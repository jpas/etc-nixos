{ lib
, ...
}:

with lib;

{
  imports = [
    ../hardware/wifi.nix
    ../hardware/bluetooth.nix
    ../hardware/dell-u2720q.nix
    ../hardware/dell-xps-13-9300.nix
    ../hardware/keychron-k3.nix
    ../hardware/logitech-mx-master-3.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/aebb4b40-046d-4cd0-98e6-d67d5bddad6d";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/DB68-692C";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/var/swapfile";
    # For systems with more than 1GB of RAM, Ubuntu recommends swap size to
    # be greater than or equal to the square root of the total RAM.
    # For hibernation, swap should be total RAM plus the above minimum.
    # TODO: set nocow on btrfs
    size = (16 + 4) * 1024;
  }];

  services.undervolt = {
    enable = mkDefault true;
    # *** WARNING *** these were tweaked specifically for my machine, using
    # them on your own machine may result in instability
    temp = 93;
    coreOffset = -69;
  };
}
