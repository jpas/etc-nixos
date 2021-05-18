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

  networking.firewall = {
    allowedUDPPorts = [ 3478 4379 4380 ];
    allowedUDPPortRanges = [ { from = 27000; to = 27100; } ];
  };

  systemd.tmpfiles.rules = let
    mkLink = path: "L+ ${path} - - - - /persist${path}";
  in [
    (mkLink "/etc/machine-id")
    (mkLink "/etc/nixos")
  ];
}
