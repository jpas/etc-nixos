{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ../../programs/steam.nix
  ];
}
