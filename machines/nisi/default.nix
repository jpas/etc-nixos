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
  };

  networking.interfaces = {
    wlan0.useDHCP = true;
  };

  networking.wireless.iwd.enable = true;
}

