{
  imports = [
    ../hardware/keychron-k3.nix
    ../hardware/logitech-mx-master-3.nix
    ../hardware/amd-gpu.nix
    ../hardware/intel-cpu.nix
  ];

  boot.initrd.luks.devices.vessel = {
    device = "/dev/disk/by-uuid/b5a8ab15-72a0-4b5d-9500-71e76207d76f";
  };

  fileSystems =
    let
      vessel = {
        subvol,
        # XXX: compression cannot actually be set per subvol like this.
        # see: https://btrfs.wiki.kernel.org/index.php/Compression
        compress ? "zstd",
        options ? [ ]
      }: {
        device = "/dev/disk/by-uuid/ebf76c7b-14f1-4c23-8eb5-7931388c83e3";
        fsType = "btrfs";
        options = [ "subvol=${subvol}" "compress=${compress}" "space_cache=v2" ] ++ options;
        neededForBoot = true;
      };
    in
    {
      "/boot" = {
        device = "/dev/disk/by-uuid/4549-DE62";
        fsType = "vfat";
      };

      "/" = vessel {
        subvol = "@";
        options = [ "relatime" ];
      };

      "/nix" = vessel {
        subvol = "@nix";
        options = [ "noatime" ];
      };
    };
}
