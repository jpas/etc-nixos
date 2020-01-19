{ config, pkgs, ... }:
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

    displayManager.sddm.enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ i3lock dmenu i3status ];
    };
  };
}
