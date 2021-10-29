{ lib
, config
, options
, pkgs
, ...
}:

with lib;

{
  imports = [
    ./base.nix
    ./desktop.nix
    ./games.nix
    ./laptop.nix
  ];

  # Essential packages.
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      cachix
      ;
  };

  boot.supportedFilesystems = [ "ntfs" "btrfs" ];

  boot.loader = {
    timeout = mkDefault 1;
    systemd-boot = {
      enable = mkDefault true;
      configurationLimit = 7;
    };
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

  networking = {
    useDHCP = mkDefault false; # This will become the default eventually.

    useNetworkd = mkDefault true;

    wireless.iwd.settings = {
      General = {
        EnableNetworkConfiguration = true;
      };
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 2048;
      };
    };
    networkmanager.wifi.backend = mkDefault "iwd";
  };

  systemd.network.links = {
    "98-persistent-names" = {
      matchConfig.Name = "*";
      linkConfig = {
        NamePolicy = "keep kernel database onboard slot path mac";
        AlternativeNamesPolicy = "database onboard slot path mac";
      };
    };
  };

  systemd.network.networks = {
    "40-ether-dhcp" = {
      matchConfig.Type = "ether";
      networkConfig.DHCP = "yes";
      dhcpV4Config.RouteMetric = 1024;
    };
  };

  services.upower.enable = mkDefault config.powerManagement.enable;

  users = {
    mutableUsers = false;
    users.root.passwordFile = "/etc/nixos/secrets/passwd.d/root";
  };

  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  system.autoUpgrade.enable = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?
}
