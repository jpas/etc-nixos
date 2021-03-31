{ lib
, config
, pkgs
, ...
}:

with lib;

{
  imports = [ ./graphical.nix ];

  config = mkMerge [{
    programs.sway = {
      enable = true;

      wrapperFeatures = {
        base = true;
        gtk = true;
      };

      extraSessionCommands = ''
        export MOZ_ENABLE_WAYLAND=1

        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1

        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

        export SDL_VIDEODRIVER=wayland
        export XDG_CURRENT_DESKTOP=sway

        systemctl --user import-environment
      '';

      extraPackages = with pkgs; [
        firefox-bin
        grim
        kanshi
        kitty
        slurp
        swayidle
        swaylock
        wlsunset
        xwayland
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        # required to get gtk apps to find the correct theme
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };

    environment.systemPackages = with pkgs; [
      qt5.qtwayland
    ];
  }];
}
