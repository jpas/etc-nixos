{ pkgs, ... }:
{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";

    # Enable touchpad support.
    libinput.enable = true;

    displayManager.gdm.enable = true;

    desktopManager.gnome3.enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ i3lock dmenu i3status ];
    };
  };

  environment.extraInit = ''
    # remove these two to maintain consistency
    rm -f ~/.config/Trolltech.conf
    rm -f ~/.config/gtk-3.0/settings.ini
  '';

  #  # GTK3: add arc theme to search path for themes
  #  export XDG_DATA_DIRS="${pkgs.arc-theme}/share:$XDG_DATA_DIRS"

  #  # ensure xdg home is set up properly
  #  export XDG_CONFIG_HOME=$HOME/.config
  #  export XDG_DATA_HOME=$HOME/.local/share
  #  export XDG_CACHE_HOME=$HOME/.cache
  #'';

  # QT4/5 global theme
  #environment.etc."xdg/Trolltech.conf" = {
  #  text = ''
  #    [Qt]
  #    style=${theme.qt}
  #  '';
  #  mode = "444";
  #};

  #qt5 = {
  #  enable = true;
  #  style = "gtk2";
  #  platformTheme = "gtk2";
  #};

  environment.etc."xdg/gtk-2.0/gtkrc" = {
    text = ''
      gtk-icon-theme-name="Papirus-Dark"
      gtk-theme-name="Arc-Dark"
    '';
    mode = "444";
  };

  environment.etc."xdg/gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-icon-theme-name=Papirus-Dark
      gtk-theme-name=Arc-Dark
    '';
    mode = "444";
  };

  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    arc-theme
    firefox
  ];

  #environment.pathsToLink = [ "/share" ];
}
