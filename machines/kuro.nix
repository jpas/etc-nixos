{ lib, pkgs, ... }:
let
  hostName = "kuro";
  domain = "jpas.xyz";
in {
  imports = [
    ../config/base.nix
    ../roles/laptop.nix
    ../roles/workstation.nix
    ../users/jpas.nix
  ];

  # Define your hostname.
  networking.hostName = "${hostName}.${domain}";
  networking.domain = domain;
  services.avahi.hostName = hostName;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable firmware update daemon.
  services.fwupd.enable = true;

  # Lets try some bleeding stuff to make WiFi work...
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing;

  environment.systemPackages = with pkgs;
    [
      libsmbios # For Dell BIOS/UEFI
    ];
}

