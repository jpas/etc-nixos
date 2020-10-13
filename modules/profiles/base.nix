{ pkgs, options, ... }: {
  imports = [ ../../hardware-configuration.nix ];

  # Essential packages.
  environment.systemPackages = with pkgs; [ curl wget neovim tmux manpages ];

  # Boot faster!
  boot.loader.timeout = 1;

  boot.tmpOnTmpfs = true;

  # Set your time zone.
  time.timeZone = "America/Regina";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  console = {
    useXkbConfig = true;
    colors = [
      # gruvbox dark
      "282828"
      "cc241d"
      "98971a"
      "d79921"
      "458588"
      "b16286"
      "689d6a"
      "a89984"
      "928374"
      "fb4934"
      "b8bb26"
      "fabd2f"
      "83a598"
      "d3869b"
      "8ec07c"
      "ebdbb2"
    ];
  };

  services.xserver = {
    # Does not enable xserver, but make sure the keymap is in sync
    layout = "us";
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users = {
    # Disble mutation of users.
    mutableUsers = false;

    # Read root's hashed password from file to prevent lockout
    users.root.hashedPassword = (import ../../secrets/passwords.nix).root;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?

  # We like to live really dangerously!
  system.autoUpgrade.enable = false;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ../../overlays/mine)
    ];
  };

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 7d";

    nixPath =
      options.nix.nixPath.default ++
      [ "nixpkgs-overlays=/etc/nixos/lib/overlays-compat" ];
  };
}
