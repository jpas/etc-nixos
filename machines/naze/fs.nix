{
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/c9561805-9e61-4e00-956e-f3a98c74c4bf";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f0b6e9bc-a690-4cc0-96bc-0dab61556e5e";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/f0b6e9bc-a690-4cc0-96bc-0dab61556e5e";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };
}

