{ ... }:
{
  imports = [
    ./programs/bash.nix
    ./programs/bat.nix
    ./programs/direnv.nix
    ./programs/exa.nix
    ./programs/fd.nix
    ./programs/firefox.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/go.nix
    ./programs/htop.nix
    ./programs/jq.nix
    ./programs/kitty.nix
    ./programs/nvim.nix
    ./programs/readline.nix
    ./programs/tmux.nix

    ./services/gnome.nix
    ./services/lorri.nix
    ./services/xdg.nix
  ];
}
