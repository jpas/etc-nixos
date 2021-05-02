{ lib
, pkgs
, ...
}:

{
  networking.hostName = "kuro";

  imports = [
    ../common
    ./hardware.nix
    ./kanshi.nix

    ../../profiles/users/jpas
  ];

  profiles = {
    graphical = true;
    laptop = true;
  };

  programs.sway.enable = true;

  hole.profiles = {
    minimal = false;
    graphical = true;
  };

  networking.interfaces = {
    wlan0.useDHCP = true;
  };

  fileSystems."/aleph" = {
    device = "kado.o:/aleph";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noatime"
      "nodiratime"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
    ];
  };
}
