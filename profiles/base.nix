{ config
, options
, pkgs
, ...
}:

{
  imports = [ ../hardware-configuration.nix ../modules/nixos ../secrets ];

  # Essential packages.
  environment.systemPackages = with pkgs; [
    curl
    htop
    kitty.terminfo
    manpages
    neovim
    tmux
    wget
  ];

  networking.useDHCP = false;

  # Boot faster!
  boot.loader.timeout = 1;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.tmpOnTmpfs = true;

  # Set your time zone.
  time.timeZone = "America/Regina";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  console = {
    useXkbConfig = true;
    colors = config.hole.colors.gruvbox.dark-no-hash.console;
  };

  services.xserver = {
    # Does not enable xserver, but make sure the keymap is in sync
    layout = "us";
  };

  networking.networkmanager.wifi.backend = "iwd";

  services.upower.enable = config.powerManagement.enable;

  users = {
    # Disble mutation of users.
    mutableUsers = false;

    # Read root's hashed password from file to prevent lockout
    users.root.hashedPassword = config.hole.secrets.passwd.root;
  };

  # We like to live really dangerously!
  system.autoUpgrade.enable = false;

  nixpkgs = {
    config = { allowUnfree = true; };
    overlays = [ (import ../pkgs/overlay.nix) ];
  };

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 30d";

    nixPath =
      let
        overlays-compat = pkgs.writeTextFile {
          name = "overlays-compat";
          destination = "/overlays.nix";
          text = ''
            final: prev:

            with prev.lib;

            let
              # Load the system config and get the `nixpkgs.overlays` option
              overlays = (import <nixpkgs/nixos> { }).config.nixpkgs.overlays;
            in
              # Apply all overlays to the input of the current "main" overlay
              foldl' (flip extends) (_: prev) overlays final
          '';
        };
      in
      options.nix.nixPath.default ++ [ "nixpkgs-overlays=${overlays-compat}" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?
}
