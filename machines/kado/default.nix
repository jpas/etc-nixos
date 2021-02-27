{ config, pkgs, ... }: {
  networking.hostName = "kado";

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing;

  hardware.cpu.intel.updateMicrocode = true;

  networking.interfaces = {
    enp0s20f0.useDHCP = true;
    enp0s20f1.useDHCP = true;
    enp0s20f2.useDHCP = true;
    enp0s20f3.useDHCP = true;
  };

  services.pipewire.media-session.enable = config.services.pipewire.enable;

  networking.firewall.allowedTCPPorts = [
    80
    443
    9091 # What am I used for?
  ];

  imports = [
    ../common.nix

    ../../profiles/base.nix
    ../../profiles/users/jpas

    ./factorio.nix
    ./nfs.nix
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "Wed *-*-1..7 4:00";
    fileSystems = [ "/data" ];
  };

  services.fail2ban.enable = true;

  virtualisation.docker.enable = true;
}
