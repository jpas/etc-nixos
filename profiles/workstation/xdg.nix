{ lib, config, pkgs, ... }:

with lib;

{
  environment.systemPackages = attrValues {
    inherit (pkgs) xdg-user-dirs xdg-utils;
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=system/desktop
    DOWNLOAD=downloads
    TEMPLATES=system/templates
    PUBLICSHARE=system/public
    DOCUMENTS=documents
    MUSIC=media/music
    PICTURES=media/photos
    VIDEOS=media/video
  '';
}
