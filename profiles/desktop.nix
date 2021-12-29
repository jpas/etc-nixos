{ lib
, config
, pkgs
, ...
}:

with lib;

{
  config = mkIf (config.hole.profiles ? desktop) (mkMerge [
    {
      hardware.opengl = {
        enable = mkDefault true;
        driSupport = mkDefault config.hardware.opengl.enable;
        driSupport32Bit = mkDefault config.hardware.opengl.driSupport;
      };

      environment.systemPackages = builtins.attrValues {
        inherit (pkgs) xdg-user-dirs xdg-utils;
      };
    }

    {
      environment.systemPackages = builtins.attrValues {
        inherit (pkgs) adwaita-qt;
        inherit (pkgs.gnome3) adwaita-icon-theme gnome-themes-extra;
        inherit (pkgs.qt5) qtwayland;
      };

      qt5 = {
        enable = mkDefault true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      environment.etc."gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = Adwaita-dark
        gtk-icon-theme-name = Adwaita
        gtk-cursor-theme-name = Adwaita
        gtk-application-prefer-dark-theme = true
        gtk-font-name = "sans 10"
      '';

      environment.etc."xdg/user-dirs.defaults".text = ''
        DESKTOP=system/desktop
        DOWNLOAD=downloads
        TEMPLATES=system/templates
        PUBLICSHARE=system/public
        DOCUMENTS=documents
        MUSIC=media/music
        PICTURES=media/photos
        VIDEOS=media/video
      '';
    }

    {
      fonts.fonts = builtins.attrValues {
        inherit (pkgs)
          jetbrains-mono
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          noto-fonts-extra
          ;
      };

      fonts.fontconfig = {
        defaultFonts = {
          emoji = mkDefault [ "Noto Color Emoji" ];
          monospace = mkDefault [ "JetBrains Mono" "Noto Sans Mono" ];
          sansSerif = mkDefault [ "Noto Sans" ];
          serif = mkDefault [ "Noto Serif" ];
        };
        cache32Bit = mkDefault true;
      };
    }

    (mkIf config.programs.sway.enable {
      programs.sway = {
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
          firefox
          grim
          kanshi
          kitty
          slurp
          swayidle
          swaylock
          wl-clipboard
          wlsunset
          xwayland
        ];
      };

      xdg.portal = {
        enable = mkDefault true;
        extraPortals = with pkgs; [
          # required to get gtk apps to find the correct theme
          xdg-desktop-portal-gtk
        ];
        gtkUsePortal = mkDefault true;

        wlr = {
          enable = mkDefault true;
          settings.screencast =
            let
              clear = "00000000";
              selected = "${config.hole.colors.gruvbox.dark.aqua0}7f";
              cmd = concatStringsSep " " [
                "${pkgs.slurp}/bin/slurp -or"
                "-f %o"
                "-B ${clear}"
                "-b ${clear}"
                "-s ${selected}"
                "-w 0"
              ];
            in
            {
              chooser_type = mkDefault "simple";
              chooser_cmd = mkDefault cmd;
            };
        };
      };
    })
  ]);
}
