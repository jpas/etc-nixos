{ config
, pkgs
, ...
}:

{
  networking.hostName = "kado";

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;
  hardware.cpu.intel.updateMicrocode = true;

  imports = [
    ./hardware.nix

    ../common

    ../../profiles/base.nix

    ../../profiles/users/jpas
    ../../profiles/users/kbell

    ./factorio.nix
    ./nfs.nix
    #./samba.nix
    ./croc.nix
    ./print-and-scan.nix
  ];

  networking.interfaces = {
    enp0s20f0.useDHCP = true;
    enp0s20f1.useDHCP = true;
    enp0s20f2.useDHCP = true;
    enp0s20f3.useDHCP = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    5201
    9091 # TODO: transmission
  ];

  networking.firewall.allowedUDPPorts = [
    5201
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "Wed *-*-1..7 4:00";
    fileSystems = [ "/aleph" ];
  };

  services.fail2ban.enable = true;

  virtualisation.docker.enable = true;
}
