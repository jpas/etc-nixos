{ ... }: 
{
  networking.hostName = "kado"; 

  networking.interfaces = {
    enp0s20f0.useDHCP = true;
    enp0s20f1.useDHCP = true;
    enp0s20f2.useDHCP = true;
    enp0s20f3.useDHCP = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    9091 # What am I used for?
  ];

  imports = [
    ../../profiles/base.nix
    ../../profiles/users/jpas

    ./factorio.nix
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "Wed *-*-1..7 4:00";
    fileSystems = [ "/data" ];
  };

  services.fail2ban.enable = true;

  virtualisation.docker.enable = true;
}
