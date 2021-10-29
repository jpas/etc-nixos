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
      laptop = true;
      graphical = true;
      games = true;
    };
    aleph.enable = true;
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
