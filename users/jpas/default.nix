{ lib
, config
, pkgs
, ...
}:

with lib;

{
  imports = [
    ./bash.nix
    ./email.nix
    ./firefox.nix
    ./imv.nix
    ./kitty.nix
    ./neovim.nix
    ./spotifyd.nix
    ./sway.nix
    ./tmux.nix
    #./xplr.nix
    ./zathura.nix
  ];

  config = mkMerge [
    {
      home.packages = with pkgs; [
        coreutils
        duf
        fd
        file
        gnumake
        hledger
        hledger-web
        (hunspellWithDicts [ hunspellDicts.en_CA-large ])
        nixpkgs-fmt
        p7zip
        python3
        ripgrep
        rmapi
        tmux
      ];

      programs.bash.enable = true;

      #programs.doom-emacs = {
      #  enable = true;
      #  extraPackages = [ pkgs.agda ];
      #  doomPrivateDir = ./doom.d;
      #};

      programs.jq.enable = true;

      programs.bat = {
        enable = true;
        catAlias = true;
        config = { theme = "gruvbox-dark"; };
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    }

    {
      programs.exa = {
        enable = true;
      };
    }

    {
      programs.fzf = {
        enable = true;
        defaultCommand = "fd --type f --follow";
        defaultOptions = [ "--layout=reverse" "--inline-info" "--color=16" ];
      };
    }

    {
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
    }

    {
      xdg.configFile."go/env".text = ''
        GOPATH=$XDG_DATA_HOME/go
        GOMODCACHE=$XDG_CACHE_HOME/go/mod
      '';
    }

    {
      # TODO: import ~/.config/op?
    }

    {
      # TODO: https://doc.rust-lang.org/cargo/guide/cargo-home.html
    }

    {
      # TODO: garbage from electron apps in ~/.config/*
    }

    {
      programs.htop.enable = true;
    }

    {
      programs.neovim.enable = true;
    }

    {
      #programs.readline = {
      #  enable = true;
      #  variables = { editing-mode = "vi"; };
      #};
    }

    {
      xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
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

    (mkIf (! (config.hole.profiles ? minimal)) {
      home.packages = with pkgs; [
        #sage # XXX: forces compile (2021-03-08)
      ];
    })

    (mkIf (config.hole.profiles ? desktop) {
      wayland.windowManager.sway.enable = true;

      #services.spotifyd.enable = true;
      programs.imv.enable = true;
      programs.kitty.enable = true;
      programs.mako.enable = true;
      programs.mpv.enable = true;
      programs.signal.enable = true;
      programs.zathura.enable = true;

      xdg.mimeApps.enable = true;

      home.packages = with pkgs; [
        discord
        teams
      ];
    })
  ];
}
