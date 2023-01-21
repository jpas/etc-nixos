{ lib
, ...
}:

with lib;

let
  tank = subvol: cfg: recursiveUpdate cfg {
    device = "/dev/mapper/tank";
    fsType = "btrfs";
    options = [ "subvol=${subvol}" ] ++ (cfg.options or [ ]);
  };
in
{
  boot.initrd.luks.devices."tank" = {
    device = "/dev/disk/by-partlabel/tank";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/boot";
    fsType = "vfat";
  };

  fileSystems."/" = tank "/root" { options = [ "compress=zstd" ]; };
  fileSystems."/nix" = tank "/nix" { options = [ "noatime" ]; };

  fileSystems."/home" = tank "/home" { };
  fileSystems."/srv" = tank "/srv" { };
  fileSystems."/var" = tank "/var" { };
  fileSystems."/var/tmp" = tank "/tmp" { };
}

