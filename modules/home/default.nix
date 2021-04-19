{ ... }:
{
  imports = [
    ../hole/home

    ./programs/bat.nix
    ./programs/imv.nix
    ./programs/signal.nix

    ./services/gnome.nix
  ];
}
