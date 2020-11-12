{ pkgs
, lib
, ...
}:
let
  hasGUI = (import <nixpkgs/nixos> { }).config.services.xserver.enable;
in
if hasGUI then {
  home.packages = with pkgs; [
    gnome3.gnome-tweaks
    pkgs.capitaine-cursors
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark-compact";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # TODO(jpas): sources = [("xkb", "us")];
      xkb-options = [ "lv3:ralt_switch" "caps:escape" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>w" ];
      minimize = [ "<Super>m" ];
    };

    "org/gnome/mutter" = {
      edge-tiling = false; # pop-shell is more featureful

      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary-display = true;
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ "<Super>x" ];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      tile-by-default = true;
      show-title = true;

      active-hint = false;
      hint-color-rgba = "rgba(251, 184, 108, 1)";

      smart-gaps = true;
      gap-inner = lib.hm.gvariant.mkUint32 1;
      gap-outer = lib.hm.gvariant.mkUint32 1;

      snap-to-grid = false;
      column-size = lib.hm.gvariant.mkUint32 64;
      row-size = lib.hm.gvariant.mkUint32 64;

      # Launcher
      activate-launcher = [ "<Super>slash" ];
      tile-enter = [ "<Super>t" ];
      tile-orientation = [ "<Super>o" ];
      toggle-floating = [ "<Super>g" ];
      toggle-stacking-global = [ "<Super>s" ];
      toggle-tiling = [ "<Super>y" ];

      # Focus Shifting
      focus-left = [ "<Super>Left" "<Super>h" ];
      focus-down = [ "<Super>Down" "<Super>j" ];
      focus-up = [ "<Super>Up" "<Super>k" ];
      focus-right = [ "<Super>Right" "<Super>l" ];

      # Tile Management Mode
      management-orientation = [ "o" ];
      tile-accept = [ "Return" ];
      tile-move-down = [ "Down" "j" ];
      tile-move-left = [ "Left" "h" ];
      tile-move-right = [ "Right" "l" ];
      tile-move-up = [ "Up" "k" ];
      tile-reject = [ "Escape" ];
      toggle-stacking = [ "s" ];

      # Resize in normal direction
      tile-resize-left = [ "<Shift>Left" "<Shift>h" ];
      tile-resize-down = [ "<Shift>Down" "<Shift>j" ];
      tile-resize-up = [ "<Shift>Up" "<Shift>k" ];
      tile-resize-right = [ "<Shift>Right" "<Shift>l" ];

      # Swap windows
      tile-swap-left = [ "<Primary>Left" "<Primary>h" ];
      tile-swap-down = [ "<Primary>Down" "<Primary>j" ];
      tile-swap-up = [ "<Primary>Up" "<Primary>k" ];
      tile-swap-right = [ "<Primary>Right" "<Primary>l" ];

      # Workspace Management -->
      pop-workspace-down = [ "<Super><Shift>Down" "<Super><Shift>j" ];
      pop-workspace-up = [ "<Super><Shift>Up" "<Super><Shift>k" ];
      pop-monitor-down = [ "<Super><Shift><Primary>Down" "<Super><Shift><Primary>j" ];
      pop-monitor-up = [ "<Super><Shift><Primary>Up" "<Super><Shift><Primary>k" ];
      pop-monitor-left = [ "<Super><Shift><Primary>Left" "<Super><Shift><Primary>h" ];
      pop-monitor-right = [ "<Super><Shift><Primary>Right" "<Super><Shift><Primary>l" ];
    };

  };
}
else {
}
