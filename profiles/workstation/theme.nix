{ lib, pkgs, ... }:

with lib;

{
  programs.sway = {
    extraPackages = attrValues {
      inherit (pkgs.gnome3) adwaita-icon-theme gnome-themes-extra;
      inherit (pkgs.qt5) qtwayland;
    };

    extraSessionCommands = mkBefore ''
      export GTK_THEME=Adwaita-dark
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';
  };

  gtk.iconCache.enable = mkDefault true;

  qt5.enable = mkDefault true;
  qt5.platformTheme = "gnome";
  qt5.style = "adwaita-dark";

  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme = true
    gtk-cursor-theme-name = Adwaita
    gtk-font-name = "sans 10"
    gtk-icon-theme-name = Adwaita
    gtk-theme-name = Adwaita-dark
  '';
}

