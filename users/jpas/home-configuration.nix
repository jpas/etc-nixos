{ pkgs, ... }:
let
  nixosConfig = (import <nixpkgs/nixos> {}).config;
  hasGUI = nixosConfig.services.xserver.enable;
in rec {
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
    gnome3.gnome-tweaks
    kitty
    signal-desktop
    steam
  ] 
  else []);

  programs.bash.enable = false;
  programs.bat.enable = true;
  programs.direnv.enable = true;

  programs.go = {
    enable = true;
    goPath = ".local/share/go";
  };

  programs.firefox = {
    # This doesn't work properly yet...
    enable = false;
    #enable = hasGUI;

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

  services.lorri.enable = true;

  dconf.settings = { };

  qt = {
    enable = hasGUI;
    platformTheme = "gnome";
  };

  gtk = {
    enable = hasGUI;
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
