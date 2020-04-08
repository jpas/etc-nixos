{ pkgs, ... }: {
  fonts = {
    fontconfig.penultimate.enable = true;
    fonts = with pkgs; [
      dejavu_fonts
      hack-font
      libertinus
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];
  };
}
