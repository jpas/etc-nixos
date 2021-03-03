{ lib, config, pkgs, ... }:

with lib;

let

  profiles = config.hole.profiles;

in
{
  imports = [
    ./bash.nix
    ./firefox.nix
    ./imv.nix
    ./kitty.nix
    ./mako.nix
    ./neovim.nix
    ./sway
    ./tmux.nix
    ./zathura.nix
  ];

  config = mkMerge [
    {
      home.packages = with pkgs; [
        _1password
        coreutils
        duf
        fd
        file
        (hunspellWithDicts [ hunspellDicts.en_CA-large ])
        gnumake
        nixfmt
        p7zip
        python3
        ripgrep
        rmapi
        s-tui
        tmux
      ];

      programs.bash.enable = true;

      programs.jq.enable = true;

      programs.bat = {
        enable = true;
        catAlias = true;
        config = { theme = "gruvbox-dark"; };
      };

      programs.exa = {
        enable = true;
        lsAlias = true;
      };

      programs.fzf = {
        enable = true;
        defaultCommand = "fd --type f --follow";
        defaultOptions = [ "--layout=reverse" "--inline-info" "--color=16" ];
      };

      programs.git = {
        enable = true;
        lfs.enable = true;
        userName = "Jarrod Pas";
        userEmail = "jarrod@jarrodpas.com";
        extraConfig = {
          pull = { ff = "only"; };
          status = { submodulesummary = 1; };
          submodule = { recurse = true; };
        };
      };

      programs.go = { goPath = ".local/share/go"; };

      programs.htop = {
        enable = true;
        hideKernelThreads = true;
        hideUserlandThreads = true;
        showProgramPath = false;
        treeView = true;
      };

      programs.neovim.enable = true;

      programs.readline = {
        enable = true;
        variables = { editing-mode = "vi"; };
      };

      xdg = {
        enable = true;
        userDirs = {
          desktop = "$HOME/opt";
          documents = "$HOME/documents";
          download = "$HOME/download";
          music = "$HOME/music";
          pictures = "$HOME/pictures";
          publicShare = "$HOME/opt";
          templates = "$HOME/opt";
          videos = "$HOME/opt";
        };
      };
    }

    (mkIf (!profiles.minimal) {
      home.packages = with pkgs; [ sage ];

      programs.direnv.enable = true;

      services.lorri.enable = true;
    })

    (mkIf profiles.graphical {
      wayland.windowManager.sway.enable = true;

      programs.imv.enable = true;
      programs.kitty.enable = true;
      programs.mako.enable = false;
      programs.mpv.enable = true;
      programs.signal.enable = true;
      programs.zathura.enable = true;

      xdg.mimeApps.enable = true;

      home.packages = with pkgs; [
        firefox-wayland
        desmume
        discord
      ];
    })
  ];
}
