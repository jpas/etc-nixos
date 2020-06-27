{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;

    desktopManager.xterm.enable = false;
  };

  environment.systemPackages = (with pkgs;
    [
      kitty # replaces gnome-terminal
      firefox-wayland # replaces epiphany
      vlc
    ] ++ (with gnomeExtensions; [
      caffeine
      draw-on-your-screen # not on stable, yet
      gsconnect
      sound-output-device-chooser
      window-is-ready-remover
    ]));

  networking.firewall.allowedUDPPorts = [
    1716 # open for gnomeExtensions.gsconnect
  ];

  # TODO: Figure out how to set default themes, maybe look at dbus.

  # Get rid of things that I do not want.
  programs.geary.enable = false;
  programs.gnome-disks.enable = false;
  programs.gnome-terminal.enable = false;
  programs.seahorse.enable = false;

  environment.gnome3.excludePackages = with pkgs.gnome3; [
    epiphany
    geary
    gedit
    gnome-maps
    gnome-music
    gnome-photos
    gnome-software
    gnome-weather
    totem
  ];
}
