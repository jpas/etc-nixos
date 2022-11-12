{ lib
, config
, ...
}:

with lib;

let
  cfg = config.programs.zathura;
  colours = config.hole.colours;
in
mkMerge [
  {
    programs.zathura = {
      options = rec {
        font = "monospace 10";

        selection-clipboard = "clipboard";
        guioptions = "";
        window-title-home-tilde = true;
        window-title-page = true;

        default-bg = colours.bg;
        default-fg = colours.fg;

        notification-error-bg = colours.bg;
        notification-error-fg = colours.red;
        notification-warning-bg = colours.bg;
        notification-warning-fg = colours.yellow;
        notification-bg = colours.bg;
        notification-fg = colours.fg;

        completion-bg = colours.bg2;
        completion-fg = colours.fg;
        completion-group-bg = colours.bg1;
        completion-group-fg = colours.fg;
        completion-highlight-bg = colours.bright.aqua;
        completion-highlight-fg = colours.bg;

        index-bg = colours.bg2;
        index-fg = colours.fg;
        index-active-bg = colours.bright.aqua;
        index-active-fg = colours.bg;

        inputbar-bg = colours.bg;
        inputbar-fg = colours.fg;

        statusbar-bg = colours.bg1;
        statusbar-fg = colours.fg;

        statusbar-h-padding = 10;
        statusbar-v-padding = 4;

        highlight-color = colours.yellow;
        highlight-active-color = colours.orange;

        render-loading = true;
        render-loading-bg = colours.bg;
        render-loading-fg = colours.fg;

        recolor = true;
        # swapped since lightcolor is usually white and dark is prefered.
        recolor-lightcolor = colours.bg;
        recolor-darkcolor = colours.fg;
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
