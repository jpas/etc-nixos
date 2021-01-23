(import ../user.nix) {
  name = "kbell";

  user = {
    uid = 1001;
    extraGroups = [
      "audio"
      "scanner"
      "networkmanager"
    ];
  };

  home = import ./home-configuration.nix;
}
