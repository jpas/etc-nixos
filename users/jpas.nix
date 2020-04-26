{ ... }: {
  imports = [ ../config/home-manager.nix ];

  users.users.jpas = {
    uid = 1000;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio"
      "scanner"
      "systemd-journal"
      "networkmanager"
    ];

    # password is in secret/passwords.nix

    isNormalUser = true;
    createHome = true;
  };

  home-manager.users.jpas = import ./jpas-home.nix;
}
