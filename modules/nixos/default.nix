{
  docker = ./docker.nix;
  hole = ./hole.nix;
  secrets = ./secrets.nix;

  base = ./base;
  graphical = ./graphical.nix;
  hardware = ./hardware;
  network = ./network.nix;
  security = ./security.nix;
}
