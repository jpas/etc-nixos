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
      bluetooth = true;
      games = true;
      desktop = true;
      graphical = true;
      laptop = true;
      wireless = true;
    };
    aleph.enable = false;
  };

  programs.sway.enable = true;

  networking.firewall.allowedTCPPorts = [
    48080
  ];

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
  };

  systemd.tmpfiles.rules = let
    mkLink = path: "L+ ${path} - - - - /persist${path}";
  in [
    (mkLink "/etc/machine-id")
    (mkLink "/etc/nixos")
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
