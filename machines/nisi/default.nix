{ lib
, config
, ...
}:

with lib;

{
  networking.hostName = "nisi";

  imports = [ ../common ];

  hole.profiles = {
    minimal = true;
  };

  networking.interfaces = {
    wlan0.useDHCP = true;
  };

  networking.wireless.iwd.enable = true;
}

