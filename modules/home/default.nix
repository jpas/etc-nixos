{ ... }: {
  imports = [
    ../hole/home

    ./programs/imv.nix
    ./programs/go.nix

    ./services/gnome.nix
  ];
}
