let
  by-uuid = {
    boot = "/dev/disk/by-uuid/4549-DE62";
    encrypted = "/dev/disk/by-uuid/8692bc12-d653-405a-9968-353e50b79556";
    decrypted = "/dev/disk/by-uuid/288cb025-d7f9-43e2-bde4-265d92e7c036";
  };
in
{
  boot.initrd.luks.devices.crypted.device = by-uuid.encrypted;

  fileSystems."/boot" = {
    device = by-uuid.boot;
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = by-uuid.decrypted;
    fsType = "btrfs";
    options = [ "subvol=/system/root" "relatime" "compress=zstd" "space_cache=v2" ];
  };

  fileSystems."/persist" = {
    device = by-uuid.decrypted;
    fsType = "btrfs";
    options = [ "subvol=/system/persist" "relatime" "compress=zstd" "space_cache=v2" ];
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = by-uuid.decrypted;
    fsType = "btrfs";
    options = [ "subvol=/local/nix" "noatime" "compress=zstd" "space_cache=v2" ];
  };

  fileSystems."/home" = {
    device = by-uuid.decrypted;
    fsType = "btrfs";
    options = [ "subvol=/user/home" "relatime" "compress=zstd" "space_cache=v2" ];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = by-uuid.decrypted;
    fsType = "btrfs";
    options = [ "subvol=/local/log" "relatime" "compress=zstd" "space_cache=v2" ];
    neededForBoot = true;
  };

  fileSystems."/var/swap" = {
    device = by-uuid.decrypted;
    fsType = "btrfs";
    options = [ "subvol=/local/swap" "noatime" "compress=no" "space_cache=v2" ];
  };

  swapDevices = [
    # For systems with more than 1GB of RAM, Ubuntu recommends swap size to
    # be greater than or equal to the square root of the total RAM.
    # For hibernation, swap should be total RAM plus the above minimum.
    { device = "/var/swap/live"; size = 4 * 1024; }
    { device = "/var/swap/hibernate"; size = 16 * 1024; }
  ];
}

