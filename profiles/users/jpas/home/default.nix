{ lib, config, pkgs, ... }:

with lib;

let profiles = config.hole.profiles;
in {
  imports = [
    ./bash.nix
    ./bat.nix
    ./exa.nix
    ./firefox.nix
    ./fzf.nix
    ./gammastep.nix
    ./git.nix
    ./htop.nix
    ./imv.nix
    ./kitty.nix
    ./nvim.nix
    ./readline.nix
    ./signal.nix
    ./sway.nix
    ./tmux.nix
    ./waybar.nix
    ./xdg.nix
    ./zathura.nix
  ];

  config = mkMerge [
    {
      home.packages = with pkgs; [
        _1password
        coreutils
        duf
        file
        s-tui
        (hunspellWithDicts [ hunspellDicts.en_CA-large ])
        gnumake
        nixfmt
        p7zip
        python3
        ripgrep
        rmapi
        tmux
        fd
      ];

      programs.bash.enable = true;

      programs.git = {
        userName = "Jarrod Pas";
        userEmail = "jarrod@jarrodpas.com";
      };

      programs.jq.enable = true;
      programs.direnv.enable = config.services.lorri.enable;

      services.lorri.enable = true;

      #programs.ssh.enable = true;
    }

    (mkIf (!profiles.minimal) { home.packages = with pkgs; [ sage ]; })

    (mkIf profiles.graphical {
      wayland.windowManager.sway.enable = true;

      programs.imv.enable = true;
      programs.kitty.enable = true;
      programs.signal.enable = true;
      programs.zathura.enable = true;

      xdg.mimeApps.enable = true;

      home.packages = with pkgs; [ discord desmume bemenu ];
    })
  ];
}
