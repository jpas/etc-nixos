{ ... }: {
  networking.hostName = "shiro"; # Define your hostname.

  imports = [
    ../hardware/logitech-mx-master-3.nix

    ../profiles/graphical.nix

    ../services/systemd-boot.nix
    ../services/games

    ../users/jpas.nix
    ../users/kbell.nix
  ];
}
