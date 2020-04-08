{ ... }:
{
  services.printing.enable = true;

  imports = [
    ../config/base.nix
    ../config/fonts.nix
    ../config/gnome3.nix
    ../config/keybase.nix
  ];
}
