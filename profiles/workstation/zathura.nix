{ lib, config, pkgs, ... }:

with lib;

let
  colours = config.hole.colours.fmt (c: "#${c}");

  format = settings: pipe settings [
    (mapAttrsToList (name: value: "set ${name} \"${toString value}\""))
    (concatStringsSep "\n")
  ];
in
{
  environment.systemPackages = [ pkgs.zathura ];

  xdg.mime.addedAssociations = {
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
  };

  environment.etc."sway/config.d/zathura.conf".text = ''
    for_window [app_id="org.pwmt.zathura"] floating enable
  '';

  environment.etc."zathurarc".text = format (with colours; {
    font = "monospace 10";

    selection-clipboard = "clipboard";
    guioptions = "";
    window-title-home-tilde = true;
    window-title-page = true;

    default-bg = bg;
    default-fg = fg;

    notification-error-bg = bg;
    notification-error-fg = neutral.red;
    notification-warning-bg = bg;
    notification-warning-fg = neutral.yellow;
    notification-bg = bg;
    notification-fg = fg;

    completion-bg = bg2;
    completion-fg = fg;
    completion-group-bg = bg1;
    completion-group-fg = fg;
    completion-highlight-bg = bright.aqua;
    completion-highlight-fg = bg;

    index-bg = bg2;
    index-fg = fg;
    index-active-bg = neutral.aqua;
    index-active-fg = bg;

    inputbar-bg = bg;
    inputbar-fg = fg;

    statusbar-bg = bg1;
    statusbar-fg = fg;

    statusbar-h-padding = 10;
    statusbar-v-padding = 4;

    highlight-color = neutral.yellow;
    highlight-active-color = neutral.orange;

    render-loading = true;
    render-loading-bg = bg;
    render-loading-fg = fg;

    recolor = true;
    # swapped since lightcolor is usually white and dark is prefered.
    recolor-lightcolor = bg;
    recolor-darkcolor = fg;
  });
}
