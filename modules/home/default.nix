{ ... }: {
  imports = [
    ../hole/home

    ./programs/bat.nix
    ./programs/exa.nix
    ./programs/imv.nix
    ./programs/signal.nix

    ./services/gnome.nix
  ];
}