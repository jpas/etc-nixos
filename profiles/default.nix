{ lib
, config
, options
, pkgs
, ...
}:

with lib;

{
  imports = [
    ../modules/nixos
    ../secrets

    ./graphical.nix
    ./laptop.nix
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  # Essential packages.
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      cachix
      curl
      htop
      manpages
      nix-output-monitor
      tmux
      wget
      ;
    kitty-terminfo = pkgs.kitty.terminfo;
  };

  # Enable documentation for development
  documentation.dev.enable = mkDefault true;

  # This will become the default eventually, but it isn't at the moment.
  networking.useDHCP = mkDefault false;

  # Boot faster!
  boot.loader.timeout = mkDefault 1;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.efi.canTouchEfiVariables = mkDefault true;

  boot.tmpOnTmpfs = mkDefault true;

  # Set your time zone.
  time.timeZone = mkDefault "America/Regina";

  # Select internationalisation properties.
  i18n.defaultLocale = mkDefault "en_CA.UTF-8";

  console = {
    useXkbConfig = mkDefault true;
    colors = mkDefault config.hole.colors.gruvbox.dark-no-hash.console;
  };

  services.xserver = {
    # Does not enable xserver, but make sure the keymap is in sync
    layout = mkDefault "us";
  };

  networking.networkmanager.wifi.backend = mkDefault "iwd";

  services.upower.enable = mkDefault config.powerManagement.enable;

  users = {
    mutableUsers = false;

    # Read root's hashed password from file to prevent lockout
    users.root.hashedPassword = config.hole.secrets.passwd.root;
  };

  system.autoUpgrade.enable = false;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ../pkgs/overlay.nix)
    ];
  };

  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

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
