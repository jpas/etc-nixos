{ lib
, pkgs
, ...
}:

with lib;

{
  networking.hostName = "shiro";
  nixpkgs.system = "x86_64-linux";

  imports = [
    ../common
    ./hardware.nix
  ];

  hole.use = {
    intel-cpu = true;
    bluetooth = true;
    sound = true;
    graphical = true;
  };

  programs.sway.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  environment.systemPackages = attrValues {
    inherit (pkgs)
      gamescope
      steam
      steam-run
      ;
  };

  systemd.network.networks = {
    "20-lan" = {
      matchConfig.Name = "enp0s25";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        DHCP = "yes";
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
