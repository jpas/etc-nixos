{ lib, pkgs, ... }: {
  networking.hostName = "kuro";

  # Lets use a new kernel!
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing;

  imports = [
    ../../profiles/base.nix
    ../../profiles/graphical.nix
    ../../profiles/games.nix

    ../../profiles/hardware/dell-u2720q.nix
    ../../profiles/hardware/dell-xps-13-9300.nix
    ../../profiles/hardware/keychron-k3.nix
    ../../profiles/hardware/logitech-mx-master-3.nix

    ../../modules/users/jpas
  ];

  # Enable documentation for development
  documentation.dev.enable = true;

  hardware.pulseaudio = {
    daemon.config = {
      avoid-resampling = true;
    };
  };

  security.audit = {
    enable = true;
    rules = [
      "-w /home/jpas/Downloads -p arwx -k stopmakingthis"
    ];
  };
}
