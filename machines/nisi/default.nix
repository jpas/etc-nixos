{ lib
, config
, ...
}:

with lib;

{
  networking.hostName = "nisi";

  imports = [
    ../common
    ../../profiles/users/jpas
  ];

  hole.profiles = {
    minimal = true;
    graphical = false;
  };

  networking.interfaces = {
    wlan0.useDHCP = true;
  };

  networking.wireless.iwd.enable = true;
}

