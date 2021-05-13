let
  flake = import ./flake-compat.nix;
in
  flake.packages."${builtins.currentSystem}"
