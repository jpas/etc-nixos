{ ... }: {
  networking.hostName = "kado"; # Define your hostname.
  networking.interfaces = {
    enp0s20f0.useDHCP = true;
    enp0s20f1.useDHCP = true;
    enp0s20f2.useDHCP = true;
    enp0s20f3.useDHCP = true;
  };

  networking.firewall.allowedUDPPorts = [
    80
    443
    9091
  ];

  imports = [
    ../../profiles/base.nix

    ../../services/systemd-boot.nix
    ../../services/docker.nix

    ../../users/jpas
  ];
}
