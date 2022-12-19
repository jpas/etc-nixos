{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ./firefox.nix
    ./imv.nix
    ./kitty.nix
    ./steam.nix
    ./wl-gammarelay-rs.nix
    ./zathura.nix
  ];

  environment.systemPackages = attrValues {
    inherit (pkgs)
      git
      mpv
      ;
  };
}
