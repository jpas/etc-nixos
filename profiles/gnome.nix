{ lib, pkgs, config, ... }:

with lib;

{
  imports = [ ./graphical.nix ];

  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.xterm.enable = false;

    desktopManager.gnome3 = {
      enable = true;
      sessionPath = with pkgs;
        [
          gnome3.mutter
          # missing mutter gsettings schema
          # see: https://github.com/NixOS/nixpkgs/issues/33277
        ];
    };
  };

  environment.systemPackages = (with pkgs; [
    firefox-wayland # replaces epiphany
    gnome3.gnome-tweaks
    kitty # replaces gnome-terminal
    vlc
  ]) ++ (with pkgs.gnomeExtensions; [
    caffeine
    # draw-on-your-screen # not on stable, yet
    sound-output-device-chooser
    window-is-ready-remover
    pop-shell
  ]);

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

  home-manager.imports = [
    ({ ... }: {
      qt = {
        enable = true;
        platformTheme = "gnome";
      };

      gtk = {
        enable = true;
        theme = { name = "Adwaita-dark"; };
      };
    })
  ];
}
