{ lib
, config
, pkgs
, ...
}:

with lib;

{
  imports = [ ./base.nix ];

  config = mkMerge [
    {
      hole.profiles.graphical = true;

      services.printing.enable = true;

      hardware.opengl = {
        enable = true;
        # Enable OpenGL for 32-bit applications
        driSupport32Bit = config.hardware.opengl.enable;
      };

      services.logind.extraConfig = ''
        IdleAction=lock
      '';
    }

    {
      services.pipewire = {
        enable = true;

        alsa.enable = true;
        alsa.support32Bit = true;

        pulse.enable = true;
      };

      security.rtkit.enable = true;
    }

    {
      fonts = {
        fonts = with pkgs; [
          dejavu_fonts
          jetbrains-mono
          libertinus
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          noto-fonts-extra
        ];

        # TODO: set default fonts
        fontconfig = {
          defaultFonts = {
            # monospace = [];
            # serif = [];
            # sansSerif = [];
            # emoji = [];
          };
        };
      };
    }

    {
      environment.systemPackages = with pkgs; [
        adwaita-qt
        gnome3.adwaita-icon-theme
        gnome3.gnome-themes-extra
      ];

      qt5 = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      environment.etc."gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = Adwaita-dark
        gtk-icon-theme-name = Adwaita
        gtk-cursor-theme-name = Adwaita
        gtk-application-prefer-dark-theme = true
      '';

      home-manager.imports = [
        ({ ... }: {
          qt = {
            enable = true;
            platformTheme = "gnome";
            style = {
              name = "adwaita-dark";
              package = pkgs.adwaita-qt;
            };
          };

          gtk = {
            enable = true;
            theme = {
              name = "Adwaita-dark";
            };
          };
        })
      ];
    }
  ];
}
