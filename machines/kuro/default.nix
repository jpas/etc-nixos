{ lib, pkgs, ... }: {
  # Define your hostname.
  networking.hostName = "kuro";

  boot.supportedFilesystems = [ "ntfs" ];

  imports = [
    ../../modules/hardware/dell-xps-13-9300
    ../../modules/hardware/logitech-mx-master-3.nix

    ../../modules/profiles/graphical.nix

    ../../modules/services/systemd-boot.nix
    ../../modules/services/games

    ../../modules/users/jpas

    ./pulseaudio.nix
  ];

  # Enable documentation for development
  documentation.dev.enable = true;

  # Undervolting to improve battery life and temperatures.
  services.throttled.enable = true;
  # *** WARNING *** these were tweaked specifically for my machine, using them
  # on your own machine may result in instability
  services.throttled.extraConfig = builtins.readFile ./throttled.conf;

  # Disable thermald since it may get in the way of throttled
  services.thermald.enable = false;
}
