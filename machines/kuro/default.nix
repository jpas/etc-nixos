{
  networking.hostName = "kuro";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ../hardware/dell-u2720q.nix
    ../hardware/dell-xps-13-9300.nix
    ../hardware/keychron-k3.nix
    ../hardware/logitech-mx-master-3.nix
    ./hardware.nix
    ./fs.nix
    ./pipewire-acp-paths.nix
  ];

  boot.kernel.sysctl = {
    "dev.i915.perf_stream_paranoid" = 0;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  systemd.tmpfiles.rules = [
    # Allow usb devices to wake from sleep.
    # This enables pluging in a monitor to wake the system in clamshell mode.
    "w /sys/bus/usb/devices/usb1/power/wakeup - - - - enabled"
    "w /sys/bus/usb/devices/usb2/power/wakeup - - - - enabled"
    "w /sys/bus/usb/devices/usb3/power/wakeup - - - - enabled"
    "w /sys/bus/usb/devices/usb4/power/wakeup - - - - enabled"
  ];

  services.thermald.enable = true;

  services.undervolt.enable = true;
  services.undervolt = {
    # *** WARNING *** these were tweaked specifically for my machine, using
    # them on your own machine may result in instability
    temp = 93;
    coreOffset = -68;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
