{ lib
, config
, options
, pkgs
, ...
}:

with lib;

{
  imports = [
    ../secrets
    ./base.nix
    ./graphical.nix
    ./laptop.nix
  ];

  # Essential packages.
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      cachix
      ;
  };

  boot.loader = {
    timeout = mkDefault 1;
    systemd-boot.enable = mkDefault true;
    efi.canTouchEfiVariables = mkDefault true;
  };

  boot.tmpOnTmpfs = mkDefault true;

  console = {
    useXkbConfig = mkDefault true;
  };

  services.xserver = {
    # Does not enable xserver, but make sure the keymap is in sync
    layout = mkDefault "us";
  };

  # This will become the default eventually, but it isn't at the moment.
  networking = {
    useDHCP = mkDefault false;
    networkmanager.wifi.backend = mkDefault "iwd";
  };

  services.upower.enable = mkDefault config.powerManagement.enable;

  users = {
    mutableUsers = false;

    # Read root's hashed password from file to prevent lockout
    users.root.hashedPassword = config.hole.secrets.passwd.root;
  };

  nix = {
    optimise.automatic = true;
    gc.options = "--delete-older-than 30d";
  };

  system.autoUpgrade.enable = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?
}
