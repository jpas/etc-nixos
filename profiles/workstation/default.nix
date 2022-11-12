{ lib, ... }:

with lib;

{
  imports = [
    ../base
    ./dev.nix
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./sound.nix
    ./sway.nix
    ./xdg.nix
  ];

  services.xserver.libinput.enable = mkDefault true;

  hardware.opengl = {
    enable = mkDefault true;
    driSupport = mkDefault true;
    driSupport32Bit = mkDefault true;
  };

  environment.systemPackages = [
    kitty
    firefox
    zathura
    imv
  ];
}
