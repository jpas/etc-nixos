{ lib
, ...
}:

with lib;

{
  networking.hostName = "kuro";

  imports = [
    ../common
    ./hardware.nix
    ./kanshi.nix

    ../../profiles/users/jpas
  ];

  hole = {
    profiles = {
      graphical = true;
    };
    aleph.enable = true;
  };

  programs.sway.enable = true;

  networking.interfaces = {
    wlan0.useDHCP = true;
  };

  systemd.tmpfiles.rules = let
    mkLink = path: "L+ ${path} - - - - /persist${path}";
  in [
    (mkLink "/etc/machine-id")
    (mkLink "/etc/nixos")
  ];
}
