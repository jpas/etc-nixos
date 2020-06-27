{ lib, pkgs, ... }: {
  # Define your hostname.
  networking.hostName = "kuro";

  imports = [
    ../hardware/dell-xps-13-9300.nix
    ../hardware/logitech-mx-master-3.nix

    ../profiles/graphical.nix
    ../users/jpas.nix
  ];

  networking.firewall.allowedUDPPorts = [
    34197 # open for factorio
  ];

  # Enable documentation for development
  documentation.dev.enable = true;
}

