{ lib, pkgs, ... }:

with lib;

{
  networking.hostName = "shiro";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ../hardware/keychron-k3.nix
    ../hardware/logitech-mx-master-3.nix
    ../hardware/amd-gpu.nix
    ../hardware/intel-cpu.nix
    ./hardware.nix
    ./fs.nix
  ];

  programs.sway.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      8554
      48080
    ];
    allowedUDPPorts = [
      # don't starve together
      10999
      10998
      8000
      8001
    ];
  };

  environment.systemPackages = attrValues {
    inherit (pkgs) steam steam-run;
  };

  systemd.network.networks."20-lan0" = {
    matchConfig.Name = "enp0s25";
    linkConfig = {
      RequiredForOnline = "routable";
    };
    networkConfig = {
      DHCP = "yes";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
