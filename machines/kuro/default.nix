{
  networking.hostName = "kuro";
  nixpkgs.system = "x86_64-linux";
  boot.loader.systemd-boot.enable = true;

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

  nix.distributedBuilds = true;
  nix.settings = {
    builders-use-substitutes = true;
  };

  nix.buildMachines = [
    {
      hostName = "doko.o";
      maxJobs = 8;
      sshUser = "jpas";
      sshKey = "/home/jpas/.ssh/id_ed25519";
      supportedFeatures = [ "-" ];
      mandatoryFeatures = [ "-" ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpJREFGOU9Za2Y0MmQ2VkIyMU1kM2lQK1ZhU04wQzFsaWpOb1lmcEdWOW0gcm9vdEBkb2tvCg==";
    }
  ];
}
