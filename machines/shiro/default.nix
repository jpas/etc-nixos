{ lib
, pkgs
, ...
}:

with lib;

{
  networking.hostName = "shiro";
  nixpkgs.system = "x86_64-linux";
  boot.loader.systemd-boot.enable = true;

  imports = [
    ../common
    ./hardware.nix
  ];

  hole.profiles = {
    bluetooth = true;
    desktop = true;
    sound = true;
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
}
