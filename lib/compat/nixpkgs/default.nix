let
  flake = builtins.getFlake "pkgs";
  system = builtins.currentSystem;
in
  flake.packages.${system}
