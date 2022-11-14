{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ../base
    ./dev.nix
    ./fonts.nix
    ./gtk.nix
    ./home-manager.nix
    ./imv.nix
    ./kitty.nix
    ./qt.nix
    ./sound.nix
    ./sway.nix
    ./xdg.nix
    ./zathura.nix
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
