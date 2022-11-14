{ lib, ... }:

with lib;

{
  imports = [
    ./tofi.nix
    ./imv.nix
    ./kitty.nix
    ./mako.nix
    ./neovim.nix
    ./sway.nix
    ./tmux.nix
    ./zathura.nix
  ];

  home.packages = [ pkgs.signal-desktop ];

  programs.zathura.enable = mkDefault true;
}
