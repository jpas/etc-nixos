{ lib, config, ... }:

with lib;

let

  cfg = config.programs.zathura;

  colors = config.hole.colors.gruvbox.dark;

in mkMerge [
  {
    programs.zathura = {
      options = with colors; rec {
        font = "JetBrains Mono 10";

        selection-clipboard = "clipboard";
        guioptions = "";
        window-title-home-tilde = true;
        window-title-page = true;

        default-bg = colors.bg;
        default-fg = colors.fg;

        notification-error-bg = colors.bg;
        notification-error-fg = colors.red0;
        notification-warning-bg = colors.bg;
        notification-warning-fg = colors.yellow0;
        notification-bg = colors.bg;
        notification-fg = colors.fg;

        completion-bg = colors.bg2;
        completion-fg = colors.fg;
        completion-group-bg = colors.bg1;
        completion-group-fg = colors.fg;
        completion-highlight-bg = colors.aqua1;
        completion-highlight-fg = colors.bg;

        index-bg = colors.bg2;
        index-fg = colors.fg;
        index-active-bg = colors.aqua1;
        index-active-fg = colors.bg;

        inputbar-bg = colors.bg;
        inputbar-fg = colors.fg;

        statusbar-bg = colors.bg1;
        statusbar-fg = colors.fg;

        statusbar-h-padding = 10;
        statusbar-v-padding = 4;

        highlight-color = colors.yellow0;
        highlight-active-color = colors.orange0;

        render-loading = true;
        render-loading-bg = colors.bg;
        render-loading-fg = colors.fg;

        recolor = true;
        # swapped since lightcolor is usually white and dark is prefered.
        recolor-lightcolor = colors.bg;
        recolor-darkcolor = colors.fg;
      };
    };
  }

  (mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };

    wayland.windowManager.sway.config = {
      floating.criteria = [{ app_id = "org.pwmt.zathura"; }];
    };
  })
]
