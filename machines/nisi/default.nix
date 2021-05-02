{ ... }:
{
  networking.hostName = "nisi";

  imports = [
    ../common

    ../../base
    ../../profiles/users/jpas
  ];

  hole.profiles = {
    minimal = true;
    graphical = false;
  };

  networking.interfaces = {
    wlan0.useDHCP = true;
    eth0 = {
      ipv4.addresses = "10.39.5.1";
      prefixLength = 24;
    };
  };

  networking.wireless = {
    enable = true;
    networks = {
      "The Hole" = {
        psk = config.hole.secrets.wifi."The Hole";
      };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # TODO: routing...
}

