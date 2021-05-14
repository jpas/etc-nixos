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

  programs.sway.enable = true;

  hole.aleph.enable = true;

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
