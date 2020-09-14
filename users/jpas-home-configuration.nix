{ pkgs, ... }:
let
  #neuron = (let
  #  rev = "0c1a2296acd532a1cc54c370ddea8d012224c26e";
  #  src = builtins.fetchTarball
  #    "https://github.com/srid/neuron/archive/${rev}.tar.gz";
  #in import src { });
in rec {
  home.packages = with pkgs; [
    _1password
    (hunspellWithDicts (with pkgs.hunspellDicts; [ en_CA-large ]))
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
    file
    nixfmt
    #neuron # TODO: cachix install?

    # gui
    kitty
    discord
    emacs
    gnome3.gnome-tweaks
    signal-desktop
    steam
  ];

  #systemd.user.services.neuron = {
  #  Unit.Description = "Neuron zettelkasten service";
  #  Install.WantedBy = [ "graphical-session.target" ];
  #  Service = {
  #    ExecStart = "${neuron}/bin/neuron rib -wS";
  #  };
  #};

  #nixpkgs.config = {
  #  # TODO: sync with ~/.config/nixpkgs/config.nix
  #  allowUnfree = true;
  #};

  programs.bash.enable = false;
  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.emacs.enable = false;

  programs.go = {
    enable = true;
    goPath = ".local/share/go";
  };

  programs.firefox = {
    enable = false;
    package = pkgs.firefox-wayland;
    profiles.jpas = {
      # TODO: extensions?

      settings = {
        # Already shooting myself in the foot here, they don't need to tell me too
        "browser.aboutConfig.showWarning" = false;

        # Start with restored session
        "browser.startup.page" = 3;

        # Set default search engine
        "browser.urlbar.placeholderName" = "DuckDuckGo";

        # Dark theme
        "devtools.theme" = "dark";
        "browser.uidensity" = 1;

        # Enable loading of userChrome and userContent
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Allow for applying theme colour to Tree Style Tab icons
        "svg.context-properties.content.enabled" = true;

        # Use blank new tab page
        "browser.discovery.enabled" = false;
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "about:blank";

        # Privacy
        "app.shield.optoutstudies.enabled" = false;
        "browser.contentblocking.category" = "strict";
        "signon.rememberSignons" = false;
      };

      userChrome = ''
      /* Hide tabs unpinned tabs and new tab button */
      #tabs-newtab-button,
      #tabbrowser-arrowscrollbox tab.tabbrowser-tab:not([pinned]) {
        display: none;
      }

      /* Hide sidebar header for Tree Style Tab */
      #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
        display: none;
      }

      /* Force thin dark scrollbar */
      :root {
        scrollbar-width: thin;
        /* scrollbar-color: var(--grey-50) var(--theme-splitter-color); */
        /* inspected values from firefox dark theme */
        scrollbar-color: #737373 #38383d;
      }
      '';

      userContent = ''
      /* Force thin dark scrollbar */
      :root {
        scrollbar-width: thin;
        /* scrollbar-color: var(--grey-50) var(--theme-splitter-color); */
        /* inspected values from firefox dark theme */
        scrollbar-color: #737373 #38383d;
      }

      /* Darken about:blank */
      @-moz-document url-prefix(about:blank) {
        html > body:empty {
          background-color: #38383d !important;
          margin 0 !important;
        }
      }
      '';
    };
  };

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
    variables = { editing-mode = "vi"; };
  };

  programs.ssh.enable = false;
  programs.texlive.enable = false;
  programs.tmux.enable = false;

  services.emacs.enable = false;
  services.lorri.enable = true;

  dconf.settings = { };

  qt = {
    enable = true;
    platformTheme = "gnome";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Pop-dark";
      package = pkgs.pop-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
