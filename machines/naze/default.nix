{ lib, pkgs, ... }:

with lib;

{
  networking.hostName = "naze";

  imports = [
    ../../profiles/archetype/builder
    ../../profiles/archetype/games
    ../../profiles/archetype/workstation
    ../../profiles/hardware/bluetooth.nix
    ../../profiles/hardware/gpu-amd.nix
    ../../profiles/hardware/keyboard-keychron-k3.nix
    ../../profiles/hardware/mouse-logitech-mx-master-3.nix
    ../../profiles/hardware/wifi.nix
    ../common
    ./fs.nix
    ./hardware.nix
  ];

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

  systemd.network.networks."20-lan0" = {
    matchConfig.Name = "enp7s0";
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
