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
    ./bluetooth.nix
    ./desktop.nix
    ./laptop.nix
    ./sound.nix
    ./wireless.nix
  ];

  boot.tmpOnTmpfs = mkDefault true;
  boot.supportedFilesystems = [ "ntfs" "btrfs" ];

  boot.loader = {
    timeout = mkDefault 1;
    efi.canTouchEfiVariables = mkDefault true;

    grub = {
      enable = mkDefault false;
    };

    systemd-boot = {
      enable = mkDefault false;
      configurationLimit = mkDefault 10;
      editor = false;
    };

    generic-extlinux-compatible = {
      enable = mkDefault false;
      configurationLimit = mkDefault 10;
    };
  };

  console = {
    useXkbConfig = mkDefault true;
  };

  services.xserver = {
    # Does not enable xserver, but make sure the keymap is in sync
    layout = mkDefault "us";
  };

  networking = {
    useNetworkd = mkDefault true;
    useDHCP = mkIf config.networking.useNetworkd false;
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
      linkConfig.RequiredForOnline = "no";
    };
  };

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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?
}
