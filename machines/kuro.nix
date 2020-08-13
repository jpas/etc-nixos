{ lib, pkgs, ... }: {
  # Define your hostname.
  networking.hostName = "kuro";

  imports = [
    ../hardware/dell-xps-13-9300.nix
    ../hardware/logitech-mx-master-3.nix

    ../profiles/graphical.nix

    ../services/systemd-boot.nix
    ../services/games

    ../users/jpas.nix
  ];

  # Enable documentation for development
  documentation.dev.enable = true;
}
