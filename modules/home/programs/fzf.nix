{ pkgs, ... }: {
  imports = [ ./fd.nix ];

  programs.fzf = {
    enable = true;

    defaultCommand = "fd --type f --follow";
    defaultOptions = [ "--layout=reverse" "--inline-info" "--color=bg+:0" ];
  };
}
