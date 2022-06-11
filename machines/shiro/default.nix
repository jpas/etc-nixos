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
}
