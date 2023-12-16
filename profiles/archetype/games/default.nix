{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ../../programs/steam.nix
    ../../programs/gamescope.nix
  ];
}
