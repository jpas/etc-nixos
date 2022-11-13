{ lib, ... }:

{
  imports = [
    ./imv.nix
    ./kitty.nix
    ./mako.nix
    ./neovim.nix
    ./sway.nix
    ./tmux.nix
    ./zathura.nix
  ];
}
