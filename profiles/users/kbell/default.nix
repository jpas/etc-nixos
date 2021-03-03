(import ../user.nix) {
  name = "kbell";

  user = {
    uid = 1001;
    extraGroups = [ ];
  };

  home = { };
}
