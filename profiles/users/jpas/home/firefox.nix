{ pkgs
, ...
}:

{
  programs.firefox = {
    # This doesn't work properly yet...
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
}
