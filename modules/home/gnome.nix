{ pkgs, ... }:
let
  hasGUI = (import <nixpkgs/nixos> {}).config.services.xserver.enable;
in
{
  home.packages = with pkgs; [
    gnome3.gnome-tweaks
  ];

  qt = {
    enable = hasGUI;
    platformTheme = "gnome";
  };

  gtk = {
    enable = hasGUI;
    theme = {
      name = "Pop-dark";
      package = pkgs.pop-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
