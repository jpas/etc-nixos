{ pkgs, ... }:
let
  nixosConfig = (import <nixpkgs/nixos> {}).config;
  hasGUI = nixosConfig.services.xserver.enable;
in rec {
  imports = [
    ../../modules/home
  ];

  home.packages = with pkgs; let
    hunspell = hunspellWithDicts (with pkgs.hunspellDicts; [ en_CA-large ]);
  in [
    #scholar
    _1password
    chezmoi
    coreutils
    exa
    fd
    file
    fzf
    git
    gnumake
    hunspell
    modd
    nixfmt
    python39
    ripgrep
    tmux
  ] ++ (if hasGUI
  then [
    discord
    signal-desktop
    steam
  ]
  else []);

  programs.bash.enable = false;

  programs.git.enable = false;

  programs.ssh.enable = false;
  programs.texlive.enable = false;
  programs.tmux.enable = false;

  dconf.settings = { };
}
