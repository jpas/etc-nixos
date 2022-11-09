builtins.mapAttrs (_: p: import p) {
  docker = ./docker.nix;
  secrets = ./secrets.nix;

  use = ./use;
  network = ./network;
  security = ./security.nix;
}
