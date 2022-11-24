{
  boot.initrd.luks.devices.crypted = {
    device = "/dev/disk/by-uuid/b5a8ab15-72a0-4b5d-9500-71e76207d76f";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/434E-DE49";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ebf76c7b-14f1-4c23-8eb5-7931388c83e3";
    fsType = "btrfs";
    options = [ "subvol=@" "relatime" "compress=zstd" "space_cache=v2" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ebf76c7b-14f1-4c23-8eb5-7931388c83e3";
    fsType = "btrfs";
    options = [ "subvol=@nix" "noatime" "compress=zstd" "space_cache=v2" ];
  };

  fileSystems."/var/swap" = {
    device = "/dev/disk/by-uuid/ebf76c7b-14f1-4c23-8eb5-7931388c83e3";
    fsType = "btrfs";
    options = [ "subvol=@swap" "noatime" "compress=zstd" "space_cache=v2" ];
  };

  fileSystems."/opt/games" = {
    device = "/dev/disk/by-uuid/03d02868-9ae5-4318-8589-7cda38811352";
    fsType = "btrfs";
  };

  swapDevices = [
    { device = "/var/swap/swapfile"; }
  ];
}
