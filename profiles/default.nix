{ lib
, config
, options
, pkgs
, ...
}:

with lib;

{
  imports = [
    ./base.nix
    ./bluetooth.nix
    ./desktop.nix
    ./laptop.nix
    ./sound.nix
    ./wireless.nix
  ];
}
