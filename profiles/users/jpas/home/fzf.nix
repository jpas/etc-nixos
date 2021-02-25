{ lib, pkgs, config, ... }:

with lib;

let

  cfg = config.programs.fzf;

in mkMerge [
  {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f --follow";
      defaultOptions = [ "--layout=reverse" "--inline-info" "--color=16" ];
    };
  }

  (mkIf cfg.enable {
    home.packages = [ pkgs.fd ];
  })
]
