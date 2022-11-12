{
  networking.hostName = "kuro";
  nixpkgs.system = "x86_64-linux";
  boot.loader.systemd-boot.enable = true;

  imports = [
    ../common
    ./hardware.nix
    ./kanshi.nix
  ];

  networking.wireless.iwd.enable = true;

  hole.use = {
    bluetooth = true;
    graphical = true;
    intel-cpu = true;
    laptop = true;
    sound = true;
  };

  hole = {
    aleph.enable = false;
  };

  programs.sway.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      48080 # for random http servers
    ];
    allowedUDPPorts = [
      10999 # don't starve together forest
      10998 # don't starve together caves
    ];
  };

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
  };

  systemd.tmpfiles.rules =
    let
      mkLink = path: "L+ ${path} - - - - /persist${path}";
    in
    [
      (mkLink "/etc/machine-id")
      (mkLink "/etc/nixos")
    ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  /*
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
  */

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
