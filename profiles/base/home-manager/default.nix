{ ... }:

{
  imports = [
    ./fzf.nix
    ./tmux.nix
  ];

  systemd.user.startServices = true;
}
