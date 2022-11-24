{ lib, ... }:

with lib;

{
  boot.initrd.luks.devices.crypted = {
    device = "/dev/disk/by-uuid/75b16615-d495-4fb9-9150-4febc1c6f25e";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1874-8176";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3cc56ffc-1714-4463-9cf4-902a883eafb5";
    fsType = "btrfs";
    options = [ "subvol=@" "relatime" "compress=zstd" "space_cache=v2" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3cc56ffc-1714-4463-9cf4-902a883eafb5";
    fsType = "btrfs";
    options = [ "subvol=@nix" "noatime" "compress=zstd" "space_cache=v2" ];
  };

  fileSystems."/aleph" = {
    device = "10.39.1.20:/aleph";
    fsType = "nfs4";
    options = [ "fsc" "relatime" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b022d055-04e1-4ce6-ab01-6b66d47fd35a"; }
  ];
}
