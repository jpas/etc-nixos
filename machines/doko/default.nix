{ lib
, pkgs
, ...
}:

{
  networking.hostName = "doko";
  nixpkgs.system = "x86_64-linux";

  hole.use.intel-cpu = true;

  imports = [
    ../common
    ./hardware.nix
    ./srht.nix
    ./factorio.nix
    ./dl.nix
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
      matchConfig.Name = "enp11s0f2";
      linkConfig = {
        RequiredForOnline = "no";
      };
      networkConfig = {
        DHCP = "yes";
      };
      dhcpV4Config = {
        RouteMetric = 512;
      };
      dhcpV6Config = {
        RouteMetric = 512;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  age.secrets."cloudflare-acme-pas.sh".file = ../../secrets/cloudflare-acme-pas.sh.age;

  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "root@pas.sh";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets."cloudflare-acme-pas.sh".path;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
