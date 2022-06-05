{
  networking.hostName = "kado";
  nixpkgs.system = "x86_64-linux";
  boot.loader.systemd-boot.enable = true;

  hardware.cpu.intel.updateMicrocode = true;

  imports = [
    ../common
    ./hardware.nix
    ./aleph.nix
    ./trinity.nix
    #./factorio.nix
    ./nfs.nix
    ./print-and-scan.nix
    ./unbound.nix
    #./samba.nix
    #./croc.nix
  ];

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

  systemd.network.networks = {
    "01-unmanaged" = {
      linkConfig = {
        Unmanaged = true;
        RequiredForOnline = "no";
      };

      matchConfig.Name = [
        # "enp0s20f0"
        "enp0s20f1"
        "enp0s20f2"
        "enp0s20f3"
      ];
    };
  };
}
