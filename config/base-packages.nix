{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    neovim
    tmux
    wget
  ];
}
