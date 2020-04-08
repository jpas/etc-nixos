{ ... }:
{
  imports = [
    ../config/home-manager.nix
  ];

  users.users.jpas = {
    uid = 1000;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio"
      "scanner"
      "systemd-journal"
      "networkmanager"
    ];

    # Generated with `mkpasswd -m sha-512`
    hashedPassword = "$6$IUhiVYbf1uNK2vC$WqRJsg80aoenjtn1EQ1reJivbZ2Yew5LzP1sWAlTvpF0iwqTET5BV6IJzGpB9QyFoGerlxSnQ/lCj1RCfh1Ax.";
    isNormalUser = true;
    createHome = true;
  };

  home-manager.users.jpas = import ./jpas-home.nix;
}
