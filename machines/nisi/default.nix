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
}

