{ lib, config, ... }:

with lib;

let gruvbox = config.hole.colors.gruvbox.dark;
in {
  programs.zathura = {
    options = with gruvbox; rec {
      font = "JetBrains Mono 10";

      selection-clipboard = "clipboard";
      guioptions = "";
      window-title-home-tilde = true;
      window-title-page = true;

      default-bg = bg;
      default-fg = fg;

      notification-error-bg = default-bg;
      notification-error-fg = red0;
      notification-warning-bg = default-bg;
      notification-warning-fg = yellow0;
      notification-bg = default-bg;
      notification-fg = default-fg;

      completion-bg = bg2;
      completion-fg = default-fg;
      completion-group-bg = bg1;
      completion-group-fg = default-fg;
      completion-highlight-bg = aqua1;
      completion-highlight-fg = default-bg;

      index-bg = bg2;
      index-fg = default-fg;
      index-active-bg = aqua1;
      index-active-fg = default-bg;

      inputbar-bg = default-bg;
      inputbar-fg = default-fg;

      statusbar-bg = bg1;
      statusbar-fg = default-fg;

      statusbar-h-padding = 10;
      statusbar-v-padding = 4;

      highlight-color = yellow0;
      highlight-active-color = orange0;

      render-loading = true;
      render-loading-bg = default-bg;
      render-loading-fg = default-fg;

      recolor = true;
      # swapped since lightcolor is usually white and dark is prefered.
      recolor-lightcolor = default-bg;
      recolor-darkcolor = default-fg;
    };
  };

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };

  wayland.windowManager.sway.config = {
    floating.criteria = [{ app_id = "org.pwmt.zathura"; }];
  };
}
