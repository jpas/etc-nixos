{ lib, config, pkgs, ... }:

with lib;

{
  environment.systemPackages = attrValues {
    inherit (pkgs.gnome3) adwaita-icon-theme gnome-themes-extra;
  };

  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name = Adwaita-dark
    gtk-icon-theme-name = Adwaita
    gtk-cursor-theme-name = Adwaita
    gtk-application-prefer-dark-theme = true
    gtk-font-name = "sans 10"
  '';
}
