{ pkgs, ... }:
let
  nixosConfig = (import <nixpkgs/nixos> {}).config;
  hasGUI = nixosConfig.services.xserver.enable;
in rec {
  imports = [
    ../../home
  ];

  home.packages = with pkgs; let
    hunspell = hunspellWithDicts (with pkgs.hunspellDicts; [ en_CA-large ]);
  in [
    _1password
    chezmoi
    coreutils
    duf
    exa
    fd
    file
    fzf
    git
    glances
    gnumake
    hunspell
    modd
    nixfmt
    p7zip
    pandoc
    python39
    ripgrep
    rmapi
    scholar
    tectonic
    tmux
  ] ++ (if hasGUI
  then [
    discord
    signal-desktop
    spotify
    steam
    steam-run
    zoom-us
  ]
  else []);

  programs.bash.enable = false;

  programs.git.enable = false;

  programs.ssh.enable = false;
  programs.texlive.enable = false;
  programs.tmux.enable = false;

  dconf.settings = { };

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
