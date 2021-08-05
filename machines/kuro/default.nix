{
  nixpkgs.system = "x86_64-linux";

  networking.hostName = "kuro";

  imports = [
    ../common
    ./hardware.nix
    ./kanshi.nix
  ];

  hole = {
    profiles = {
      graphical = true;
      games = true;
    };
    aleph.enable = true;
  };

  programs.sway.enable = true;

  networking.interfaces = {
    wlan0.useDHCP = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  systemd.tmpfiles.rules = let
    mkLink = path: "L+ ${path} - - - - /persist${path}";
  in [
    (mkLink "/etc/machine-id")
    (mkLink "/etc/nixos")
  ];
}
