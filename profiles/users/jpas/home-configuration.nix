{ lib, config, pkgs, ... }:

with lib;

let profiles = config.hole.profiles;
in {
  imports = [ ./home ];

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
      ];

      programs.bash.enable = true;

      programs.git = {
        userName = "Jarrod Pas";
        userEmail = "jarrod@jarrodpas.com";
      };

      #programs.ssh.enable = true;
    }

    (mkIf (!profiles.minimal) { home.packages = with pkgs; [ sage ]; })

    (mkIf profiles.graphical {
      wayland.windowManager.sway.enable = true;

      programs.zathura.enable = true;

      xdg.mimeApps.enable = true;

      home.packages = with pkgs; [ discord desmume bemenu ];
    })
  ];
}
