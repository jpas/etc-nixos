{ lib, ... }:

{
  home-manager.sharedModules = [
    ./imv.nix
    ./kitty.nix
    ./mako.nix
    ./neovim.nix
    ./sway.nix
    ./tmux.nix
    ./zathura.nix
  ];
}
