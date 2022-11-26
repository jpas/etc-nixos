rec {
  flake = builtins.getFlake (toString ./.);

  inherit (flake.inputs.nixpkgs) lib;
}
