{ lib
, pkgs
, ...
}:

with lib;

let
  acp-paths = pkgs.runCommand "acp-paths" {}
    ''
      mkdir -p $out
      for f in ${pkgs.pipewire.lib}/share/alsa-card-profile/mixer/paths/*; do
        ln -s $f $out/
      done

      ${concatStringsSep "\n" (mapAttrsToList
        (name: priority: ''
          f=$out/${name}.conf
          cp --remove-destination "$(readlink "$f")" "$f"
          sed -i 's/^priority = [0-9]*/priority = ${toString priority}/' "$f"
        '')
        {
          analog-input-internal-mic = 79;
          analog-input-internal-mic-always = 79;
          analog-output-speaker = 80;
          analog-output-speaker-always = 80;
        }
      )}
    '';
in
{
  imports = [
    ../hardware/dell-u2720q.nix
    ../hardware/dell-xps-13-9300.nix
    ../hardware/keychron-k3.nix
    ../hardware/logitech-mx-master-3.nix
  ];

  boot.initrd.luks.devices.vessel = {
    device = "/dev/disk/by-uuid/8692bc12-d653-405a-9968-353e50b79556";
  };

  boot.kernel.sysctl = {
    "dev.i915.perf_stream_paranoid" = 0;
  };

  systemd.user.services.pipewire-media-session.environment = {
    ACP_PATHS_DIR = "${acp-paths}";
  };

  systemd.user.services.wireplumber.environment = {
    ACP_PATHS_DIR = "${acp-paths}";
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
        device = "/dev/disk/by-uuid/288cb025-d7f9-43e2-bde4-265d92e7c036";
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
        subvol = "/system/root";
        options = [ "relatime" ];
      };

      "/persist" = vessel {
        subvol = "/system/persist";
        options = [ "relatime" ];
      };

      "/var/log" = vessel {
        subvol = "/local/log";
        options = [ "relatime" ];
      };

      "/var/swap" = vessel {
        subvol = "/local/swap";
        compress = "no";
        options = [ "noatime" ];
      };

      "/nix" = vessel {
        subvol = "/local/nix";
        options = [ "noatime" ];
      };

      "/home" = vessel {
        subvol = "/user/home";
        options = [ "relatime" ];
      };
    };

  swapDevices = [
    {
      # For systems with more than 1GB of RAM, Ubuntu recommends swap size to
      # be greater than or equal to the square root of the total RAM.
      # For hibernation, swap should be total RAM plus the above minimum.
      device = "/var/swap/live";
      size = 4 * 1024;
    }
    {
      # TODO: only create when needed
      device = "/var/swap/hibernate";
      size = 16 * 1024;
    }
  ];

  # Allow usb devices to wake from sleep. This enables pluggin in a monitor to
  # wake the system in clamshell mode.
  systemd.tmpfiles.rules = [
    "w /sys/bus/usb/devices/usb1/power/wakeup - - - - enabled"
    "w /sys/bus/usb/devices/usb2/power/wakeup - - - - enabled"
    "w /sys/bus/usb/devices/usb3/power/wakeup - - - - enabled"
    "w /sys/bus/usb/devices/usb4/power/wakeup - - - - enabled"
  ];

  services.undervolt = {
    enable = mkDefault true;
    # *** WARNING *** these were tweaked specifically for my machine, using
    # them on your own machine may result in instability
    temp = 93;
    coreOffset = -68;
  };
}
