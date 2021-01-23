(import ../user.nix) {
  name = "jpas";

  user = {
    uid = 1000;

    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio"
      "video"
      "input"
      "networkmanager"
      "plugdev"
      "scanner"
      "systemd-journal"
      "docker"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXyVMHbf69zSybXTmyQc/CHjx7j56O/VAl7N/KsMREw jpas@kuro"
    ];
  };

  home = import ./home-configuration.nix;
}
