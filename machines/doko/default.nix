{ lib, pkgs, config, ... }:

{
  networking.hostName = "doko";
  nixpkgs.system = "x86_64-linux";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ./router.nix
    ./coredns.nix
    ./dl.nix
    ./factorio.nix
    ./hardware.nix
    ./srht.nix
    ./traefik.nix
  ];

  systemd.network.networks = {
    "20-lan" = {
      matchConfig.Name = "enp7s0";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        DHCP = "yes";
      };
    };
    "20-wan" = {
      matchConfig.Name = "enp11s0f3";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        DHCP = "yes";
        IPMasquerade = "ipv4";
        IPForward = "yes";
      };
      dhcpV4Config = {
        RouteMetric = 512;
      };
      dhcpV6Config = {
        RouteMetric = 512;
      };
    };
    "21-lan" = {
      matchConfig.Name = "enp11s0f2";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        Address = "10.39.3.1/24";
        DHCPServer = "yes";
        IPForward = "yes";
      };

      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 100;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
