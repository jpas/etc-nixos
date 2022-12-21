builtins.mapAttrs (_: p: import p) {
  authelia = ./authelia.nix;
  direnv = ./programs/direnv.nix;
  docker = ./docker.nix;
  lemurs = ./lemurs.nix;
  pam = ./pam.nix;
  sway = ./sway.nix;
  use = ./use;
}
