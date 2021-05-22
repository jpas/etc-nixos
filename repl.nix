let
  flake = builtins.getFlake (toString ./.);
  nixpkgs = import <nixpkgs> { };
  lib = nixpkgs.lib;
in {
  inherit flake nixpkgs;
  lib = nixpkgs.lib;
}
