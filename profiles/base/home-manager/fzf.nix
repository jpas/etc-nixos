{ ... }:

{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --follow";
    defaultOptions = [ "--layout=reverse" "--inline-info" "--color=16" ];
  };
}

