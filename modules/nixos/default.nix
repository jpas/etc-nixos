{
  docker = ./docker.nix;
  hole = ./hole.nix;
  secrets = ./secrets.nix;

  profile = ./profile;
  hardware = ./hardware;
  network = ./network.nix;
  security = ./security.nix;
}
