{ config
, pkgs
, ...
}:
{
  imports = [
    ./base.nix
    ../services/gnome.nix
    # sound doesn't work in fshenv applications yet...
    # ../services/pipewire.nix

  ];

  services.printing.enable = true;

  # Enable OpenGL for 32-bit applications
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Enable pulseaudio for 32-bit applications
  hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      hack-font
      libertinus
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];

    # TODO: set default fonts
    fontconfig = {
      defaultFonts = {
        # monospace = [];
        # serif = [];
        # sansSerif = [];
        # emoji = [];
      };
    };
  };
}
