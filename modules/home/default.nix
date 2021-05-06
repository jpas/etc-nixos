{ ... }:
{
  imports = [
    ../hole/home

    ./programs/bat.nix
    ./programs/imv.nix
    ./programs/oauth2ms.nix
    ./programs/signal.nix

    ./services/gnome.nix
  ];
}
