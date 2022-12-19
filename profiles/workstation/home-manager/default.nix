{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ./tofi.nix
    ./neovim.nix
    ./sway.nix
  ];
}
