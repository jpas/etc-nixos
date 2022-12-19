{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ./firefox.nix
    ./imv.nix
    ./kitty.nix
    ./mako.nix
    ./steam.nix
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
