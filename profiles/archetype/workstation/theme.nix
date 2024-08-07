{ lib, pkgs, ... }:

with lib;

{
  # TODO: fix gtk file chooser using light theme for xwayland clients

  programs.sway = {
    extraPackages = attrValues {
      inherit (pkgs) adwaita-icon-theme gnome-themes-extra;
      inherit (pkgs.qt5) qtwayland;
    };

    include."50-xcursor-theme.conf" = ''
      seat * xcursor_theme Adwaita
    '';

    extraSessionCommands = mkBefore ''
      export GTK_THEME=Adwaita-dark
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';
  };

  gtk.iconCache.enable = mkDefault true;

  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme = true
    gtk-cursor-theme-name = Adwaita
    gtk-font-name = "sans 10"
    gtk-icon-theme-name = Adwaita
    gtk-theme-name = Adwaita-dark
  '';

  qt.enable = mkDefault true;
  qt.platformTheme = "gnome";
  qt.style = "adwaita-dark";
}

