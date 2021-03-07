{ lib
, pkgs
, ...
}:

{
  networking.hostName = "kuro";

  # Lets use a new kernel!
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing;

  imports = [
    ../common

    ../../profiles/base.nix
    ../../profiles/games.nix
    ../../profiles/laptop.nix
    ../../profiles/sway.nix

    ../../profiles/hardware/dell-u2720q.nix
    ../../profiles/hardware/dell-xps-13-9300.nix
    ../../profiles/hardware/keychron-k3.nix
    ../../profiles/hardware/logitech-mx-master-3.nix

    ../../profiles/users/jpas

    ./kanshi.nix
    ./throttled.nix
  ];

  # Enable documentation for development
  documentation.dev.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = { General.FastConnectable = true; };
  };

  networking.wireless.iwd.enable = true;

  networking.interfaces = {
    wlan0.useDHCP = true;
  };

  fileSystems."/data" = {
    device = "kado.o:/data";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noatime"
      "nodiratime"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
    ];
  };

  virtualisation.docker.enable = true;
}
