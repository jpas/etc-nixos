{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ../../hardware/sound.nix
    ../../programs/_1password-gui.nix
    ../../programs/firefox.nix
    ../../programs/imv.nix
    ../../programs/kitty.nix
    ../../programs/mako.nix
    ../../programs/steam.nix
    ../../programs/sway.nix
    ../../programs/swayidle.nix
    ../../programs/swaylock.nix
    ../../programs/tofi.nix
    ../../programs/wl-gammarelay-rs.nix
    ../../programs/zathura.nix
    ../minimal
    ./sway-session.nix
    ./theme.nix
    ./xdg.nix
  ];

  programs.sway.enable = mkDefault true;

  hardware.opengl = {
    driSupport = mkDefault true;
    driSupport32Bit = mkDefault true;
  };

  documentation.dev.enable = mkDefault true;

  services.upower.enable = mkDefault true;
  services.udisks2.enable = mkDefault true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    HandlePowerKeyLongPress=poweroff
  '';

  services.libinput.enable = mkDefault true;

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = mkDefault [ "Noto Color Emoji" ];
        monospace = mkDefault [ "JetBrains Mono" ];
        sansSerif = mkDefault [ "Noto Sans" ];
        serif = mkDefault [ "Noto Serif" ];
      };
      cache32Bit = mkDefault true;
    };

    packages = attrValues {
      inherit (pkgs)
        jetbrains-mono
        noto-fonts
        #noto-fonts-cjk
        #mplus-outline-fonts
        noto-fonts-emoji
        noto-fonts-extra
        libertinus
        ;
    };
  };
}
