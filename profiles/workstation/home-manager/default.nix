{ lib, ... }:

{
  home-manager.sharedModules = [
    ./sway.nix
    ./mako.nix
  ];
}
