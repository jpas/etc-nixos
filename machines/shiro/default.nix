{ lib, pkgs, ... }:

with lib;

{
  networking.hostName = "shiro";
  boot.loader.systemd-boot.enable = true;

  imports = [
    ../../profiles/archetype/games
    ../../profiles/archetype/games/factorio.nix
    ../../profiles/archetype/games/do-not-starve-together.nix
    ../../profiles/archetype/workstation
    ../../profiles/hardware/bluetooth.nix
    ../../profiles/hardware/gpu-amd.nix
    ../../profiles/hardware/keyboard-keychron-k3.nix
    ../../profiles/hardware/mouse-logitech-mx-master-3.nix
    ../common
    ./fs.nix
    ./hardware.nix
  ];

  systemd.network.networks."20-lan0" = {
    matchConfig.Name = "enp0s25";
    linkConfig = {
      RequiredForOnline = "routable";
    };
    networkConfig = {
      DHCP = "yes";
    };
  };

  # By default the the kernel will put the intel_pstate driver in passive mode
  # as the cpu in this system does not support HWP. So we actually want to use
  # the schedutil or performance governors.
  powerManagement.cpuFreqGovernor = "performance";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
