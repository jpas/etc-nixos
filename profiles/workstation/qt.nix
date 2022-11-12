{ lib, pkgs, ... }:

with lib;

{
  environment.systemPackages = attrValues {
    inherit (pkgs) adwaita-qt;
    inherit (pkgs.qt5) qtwayland;
  };

  qt5 = {
    enable = mkDefault true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
