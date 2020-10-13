{ ... }: {
  networking.hostName = "kado"; # Define your hostname.
  networking.interfaces = {
    enp0s20f0.useDHCP = true;
    enp0s20f1.useDHCP = true;
    enp0s20f2.useDHCP = true;
    enp0s20f3.useDHCP = true;
  };

  # TODO: these are wrong...
  networking.firewall.allowedUDPPorts = [
    80
    443
    9091 # What am I used for?
  ];

  imports = [
    ../../modules/profiles/base.nix

    ../../modules/services/systemd-boot.nix
    ../../modules/services/docker.nix

    ../../modules/users/jpas
  ];
}
