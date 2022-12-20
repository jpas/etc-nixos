{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ./firefox.nix
    ./imv.nix
    ./kitty.nix
    ./mako.nix
    ./steam.nix
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
    ./tofi.nix
    ./wl-gammarelay-rs.nix
    ./zathura.nix
  ];

  environment.systemPackages = attrValues {
    inherit (pkgs)
      signal-desktop
      git
      mpv
      ;
  };
}
