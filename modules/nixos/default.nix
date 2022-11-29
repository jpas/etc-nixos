builtins.mapAttrs (_: p: import p) {
  docker = ./docker.nix;
  use = ./use;
  direnv = ./programs/direnv.nix;
  authelia = ./authelia.nix;
  pam = ./pam.nix
}
