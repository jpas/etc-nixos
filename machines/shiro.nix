{ ... }: {
  networking.hostName = "shiro"; # Define your hostname.

  imports = [
    ../profile/graphical.nix

    ../users/jpas.nix
    ../users/kbell.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.eno1.useDHCP = true;
}

