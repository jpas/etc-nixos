{ config, pkgs, ... }: {
  imports = [ ./base.nix ];

  hole.profiles.graphical = true;

  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.xterm.enable = false;
  };

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

  hardware.pulseaudio = {
    enable = !config.services.pipewire.pulse.enable;
    support32Bit = config.hardware.pulseaudio.enable;
  };

  services.printing.enable = true;

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      hack-font
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
    gtk-icon-theme-name = Adwaita
    gtk-theme-name = Adwaita-dark
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
