builtins.mapAttrs (_: p: import p) {
  docker = ./docker.nix;

  use = ./use;
}
