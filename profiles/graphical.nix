{ config, pkgs, ... }: {
  imports = [ ./base.nix ];

  hole.profiles.graphical = true;

  hardware.opengl = {
    enable = true;
    # Enable OpenGL for 32-bit applications
    driSupport32Bit = config.hardware.opengl.enable;
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = config.services.pipewire.alsa.enable;

    pulse.enable = true;
  };

  services.printing.enable = true;

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      libertinus
      jetbrains-mono
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

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs; [
    adwaita-qt
    gnome3.adwaita-icon-theme
    gnome3.gnome-themes-extra
  ];

  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name = Adwaita-dark
    gtk-icon-theme-name = Adwaita
    gtk-cursor-theme-name = Adwaita
    gtk-application-prefer-dark-theme = true
  '';

  #home-manager.imports = [
  #  ({ ... }: {
  #    qt = {
  #      enable = true;
  #      platformTheme = "gnome";
  #    };

  #    gtk = {
  #      enable = true;
  #      theme = {
  #        name = "Adwaita-dark";
  #      };
  #    };
  #  })
  #];
}
