{ pkgs, ... }: {
  home.packages = with pkgs; [
    #_1password
    (hunspellWithDicts (with pkgs.hunspellDicts; [
      en_CA-large
    ]))
    chezmoi
    coreutils
    exa
    fd
    fzf
    git
    gnumake
    modd
    python39
    ripgrep
    #scholar
    tmux

    # gui
    alacritty
    #discord
    emacs
    firefox
    gnome3.gnome-tweaks
    keybase-gui
    signal-desktop
  ];

  programs.alacritty.enable = false;
  programs.bash.enable = false;
  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.emacs.enable = false;
  programs.firefox.enable = false;
  programs.fzf.enable = false;
  programs.git.enable = false;

  programs.htop = {
    enable = true;
    hideUserlandThreads = true;
    hideKernelThreads = true;
    treeView = true;
    showProgramPath = false;
  };

  programs.jq.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.readline = {
    enable = true;
    variables = {
      editing-mode = "vi";
    };
  };

  programs.ssh.enable = false;
  programs.texlive.enable = false;
  programs.tmux.enable = false;

  services.emacs.enable = false;
  services.kbfs.enable = true;
  services.keybase.enable = true;
  services.lorri.enable = true;
  services.nextcloud-client.enable = false;

  dconf.settings = {};

  qt = {
    enable = true;
    platformTheme = "gnome";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
