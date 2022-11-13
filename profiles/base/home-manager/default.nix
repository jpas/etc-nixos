{ ... }:

{
  imports = [
    ./direnv.nix
    ./fzf.nix
    ./tmux.nix
  ];

  systemd.user.startServices = true;
}
