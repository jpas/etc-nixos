{ lib, pkgs, ... }: {
  networking.hostName = "kuro";

  # Lets use a new kernel!
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing;

  virtualisation.docker.enable = true;

  imports = [
    ../common.nix

    ../../profiles/base.nix
    #../../profiles/gnome.nix
    ../../profiles/sway.nix
    ../../profiles/games.nix

    ../../profiles/hardware/dell-u2720q.nix
    ../../profiles/hardware/dell-xps-13-9300.nix
    ../../profiles/hardware/keychron-k3.nix
    ../../profiles/hardware/logitech-mx-master-3.nix

    ../../profiles/users/jpas

    ./intel-undervolt.nix
    ./kanshi.nix
  ];

  # Enable documentation for development
  documentation.dev.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = { General.FastConnectable = true; };
  };

  networking.wireless.iwd.enable = true;

  services.throttled.enable = true;

  fileSystems."/data" = {
    device = "kado.o:/data";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
    ];
  };
}
