{ lib, pkgs, ... }:

with lib;

{
  fonts.fonts = attrValues {
    inherit (pkgs)
      jetbrains-mono
      noto-fonts
      #noto-fonts-cjk
      #mplus-outline-fonts
      noto-fonts-emoji
      noto-fonts-extra
      ;
  };

  fonts.fontconfig = {
    defaultFonts = {
      emoji = mkDefault [ "Noto Color Emoji" ];
      monospace = mkDefault [ "JetBrains Mono" ];
      sansSerif = mkDefault [ "Noto Sans" ];
      serif = mkDefault [ "Noto Serif" ];
    };
    cache32Bit = mkDefault true;
  };
}
