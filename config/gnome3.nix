{ pkgs, ... }: {
  imports = [ ./xserver.nix ];

  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;

    desktopManager.xterm.enable = false;
  };

  environment.systemPackages = (with pkgs;
    [
      alacritty # replaces gnome-terminal
      firefox # replaces epiphany
      vlc
    ] ++ (with gnomeExtensions; [
      gsconnect
      caffeine
      #draw-on-your-screen # not on stable, yet
    ]));

  networking.firewall.allowedUDPPorts = [
    1716 # open for gsconnect
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
