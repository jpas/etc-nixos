{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ../base
    ./home-manager.nix
    ./dev.nix
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./sound.nix
    ./sway.nix
    ./xdg.nix
    ./zathura.nix
    ./imv.nix
  ];

  services.xserver.libinput.enable = mkDefault true;

  hardware.opengl = {
    enable = mkDefault true;
    driSupport = mkDefault true;
    driSupport32Bit = mkDefault true;
  };

  environment.systemPackages = attrValues {
    inherit (pkgs)
    kitty
    firefox
    imv
    ;
  };

  services.udisks2.enable = true;
}
