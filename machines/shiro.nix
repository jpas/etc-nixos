{ ... }: {
  networking.hostName = "shiro"; # Define your hostname.

  imports = [
    ../hardware/logitech-mx-master-3.nix

    ../profile/graphical.nix

    ../services/systemd-boot.nix

    ../users/jpas.nix
  ];
}
