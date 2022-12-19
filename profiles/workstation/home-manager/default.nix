{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ./tofi.nix
    ./imv.nix
    ./mako.nix
    ./neovim.nix
    ./sway.nix
    ./tmux.nix
  ];

  home.packages = [ pkgs.signal-desktop ];
}
