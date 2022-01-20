{
  networking.hostName = "kuro";
  nixpkgs.system = "x86_64-linux";

  imports = [
    ../common
    ./hardware.nix
    ./kanshi.nix
  ];

  hole = {
    profiles = {
      bluetooth = true;
      desktop = true;
      games = true;
      laptop = true;
      sound = true;
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
