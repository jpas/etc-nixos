{ lib
, pkgs
, ...
}:

{
  networking.hostName = "kuro";

  # Lets use a new kernel!
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  imports = [
    ../../hardware-configuration.nix

    ../common

    ../../profiles/users/jpas

    ./hardware.nix
    ./kanshi.nix
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

  # Enable documentation for development
  documentation.dev.enable = true;

  hardware.bluetooth = {
    settings = { General.FastConnectable = true; };
  };

  networking.wireless.iwd.enable = true;

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

  #virtualisation.docker.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  #nixpkgs.overlays = [ (import <nixpkgs-he/overlay.nix>) ];
}
