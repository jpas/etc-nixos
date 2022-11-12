{ lib, pkgs, ... }:

with lib;

{
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = mkDefault true;
      gtk = mkDefault true;
    };

    extraSessionCommands = ''
      # force firefox to run in wayland
      export MOZ_ENABLE_WAYLAND=1
      # force firefox to use remote backend so apps running in xwayland
      # open links in the wayland instance.
      export MOZ_DBUS_REMOTE=1

      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1

      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP=sway

      # Shouldn't be needed since it is in /etc/gtk-3.0/settings.ini
      export GTK_THEME=Adwaita-dark

      systemctl --user import-environment
    '';

    extraPackages = with pkgs; [
      grim
      kanshi
      slurp
      swayidle
      swaylock
      wl-clipboard
      wlsunset
      xwayland
    ];
  };
}
