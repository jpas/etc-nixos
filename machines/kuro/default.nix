{
  networking.hostName = "kuro";
  nixpkgs.system = "x86_64-linux";
  boot.loader.systemd-boot.enable = true;

  imports = [
    ../common
    ./hardware.nix
    ./kanshi.nix
  ];

  hole.hardware = {
    laptop.enable = true;
    bluetooth.enable = true;
    wifi.enable = true;
    sound.enable = true;
  };

  hole.profile = {
    graphical.enable = true;
  };

  hole = {
    aleph.enable = false;
  };

  systemd.services = {
    # networkd does not manage any of the devices available at boot, thus if
    # enabled it will always timeout.
    "systemd-networkd-wait-online".enable = false;
  };

  programs.sway.enable = true;

  networking.firewall.allowedTCPPorts = [
    48080
  ];

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
