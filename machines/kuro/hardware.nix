{ lib
, ...
}:

with lib;

{
  imports = [
    ../../profiles/hardware/dell-u2720q.nix
    ../../profiles/hardware/dell-xps-13-9300.nix
    ../../profiles/hardware/keychron-k3.nix
    ../../profiles/hardware/logitech-mx-master-3.nix
  ];

  config = {
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

    services.throttled = {
      enable = mkDefault true;

      extraConfig = generators.toINI { } {
        # *** WARNING *** these were tweaked specifically for my machine, using
        # them on your own machine may result in instability
        GENERAL = { Enabled = true; };

        AC = {
          Update_Rate_s = 5;
          PL1_Tdp_W = 25;
          PL2_Tdp_W = 32;
          Trip_Temp_C = 92;
          cTDP = 2;
        };

        BATTERY = {
          Update_Rate_s = 30;
          PL1_Tdp_W = 15;
          PL2_Tdp_W = 18;
        };

        UNDERVOLT = rec {
          CORE = -66;
          CACHE = CORE; # core and cache must have the same undervolt
          GPU = 0;
          UNCORE = 0;
          ANALOGIO = 0;
        };
      };
    };
  };
}
