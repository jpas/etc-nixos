{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7932c7d2-49c2-453b-a406-4a73509a57fd";
    fsType = "ext4";
  };

  fileSystems."/aleph" = {
    device = "/dev/disk/by-uuid/8aebe979-4cbd-45c6-a83e-44a165be7226";
    fsType = "btrfs";
    options = [ "subvol=/aleph" "relatime" "autodefrag" "commit=5" "space_cache=v2" ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "Wed *-*-1..7 4:00";
    fileSystems = [ "/aleph" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E914-BBE6";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/f1476467-c295-47c7-8d0b-51dbcaf182dd"; }
  ];
}
