{ lib, pkgs, config, ... }:

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
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1

        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

        export SDL_VIDEODRIVER=wayland
        export XDG_CURRENT_DESKTOP=sway

        #source /etc/profile
        #test -f $HOME/.profile && source $HOME/.profile

        systemctl --user import-environment
      '';
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

    environment.systemPackages = with pkgs; [ qt5.qtwayland xdg-user-dirs ];
  }];
}
