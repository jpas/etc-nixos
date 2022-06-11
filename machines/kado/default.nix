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
    # jellyfin docker
    8096
    8920
    # sonarr docker
    7878
    # radarr docker
    8989
  ];

  networking.firewall.allowedUDPPorts = [
    5201
    # jellyfin docker
    1900
    7359
  ];

  services.fail2ban.enable = true;
  services.unbound.enable = true;
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
        "veth*" # docker-compose veth
      ];
    };
  };
}
