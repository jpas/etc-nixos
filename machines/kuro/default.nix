{ lib, pkgs, ... }: {
  # Define your hostname.
  networking.hostName = "kuro";

  boot.supportedFilesystems = [ "ntfs" ];

  imports = [
    ../../modules/hardware/dell-u2720q
    ../../modules/hardware/dell-xps-13-9300
    ../../modules/hardware/keychron
    ../../modules/hardware/logitech-mx-master-3.nix

    ../../modules/profiles/graphical.nix

    ../../modules/services/systemd-boot.nix
    ../../modules/services/games

    ../../modules/users/jpas

    ./pulseaudio.nix
    ./throttled.nix
  ];

  # Enable documentation for development
  documentation.dev.enable = true;

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing;

  security.audit = {
    enable = true;
    rules = [
      "-w /home/jpas/Downloads -p arwx -k stopmakingthis"
    ];
  };
}
