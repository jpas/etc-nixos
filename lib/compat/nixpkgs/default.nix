let
  flake = builtins.getFlake "pkgs";
  system = builtins.currentSystem;
in
  # TODO: warn user about nixpkgs args being ignored
  _: flake.packages.${system}
