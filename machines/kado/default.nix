{
  networking.hostName = "kado";

  nixpkgs.system = "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = true;

  imports = [
    ./hardware.nix

    ../common

    ./aleph.nix
    ./factorio.nix
    ./nfs.nix
    ./print-and-scan.nix
    ./unbound.nix
    #./samba.nix
    #./croc.nix
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

  services.fail2ban.enable = true;

  virtualisation.docker.enable = true;
}
