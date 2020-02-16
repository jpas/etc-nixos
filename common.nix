# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "America/Regina";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget curl
    vim
    tmux
  ];

  # List fonts installed in system.
  fonts = {
    fontconfig.penultimate.enable = true;
    fonts = with pkgs; [
      dejavu_fonts
      hack-font
      libertinus
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];
  };

  # Enable the Keybase daemon and filesystem.
  services.keybase.enable = true;
  services.kbfs.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Disble mutation of users.
  users.mutableUsers = false;

  # Prevent lockout...
  users.users.root.hashedPassword = "$6$nSxJ1J4lJ5w$PoC7DaVweDBiorbQfiWmnOkWAnRsHL2sYgP5LN2sAZr2EETZZAKWnYtEJ/9VRtLHGaISxEgz7qglme205lQ0y/";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?

  system.autoUpgrade.enable = true;
}
