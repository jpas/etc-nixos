{ ... }:
{
  users.users.jpas = {
    isNormalUser = true;

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

    hashedPassword = (import ../../../secrets/passwords.nix).jpas;
  };

  home-manager.users.jpas = { ... }: {
    imports = [
      ../../../modules/home/all-modules.nix
      ./home-configuration.nix
    ];
  };
}
