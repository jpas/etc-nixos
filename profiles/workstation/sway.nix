{ lib, pkgs, ... }:

with lib;

{
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = mkDefault true;
      gtk = mkDefault true;
    };

    extraSessionCommands = ''
      # force firefox to run in wayland
      export MOZ_ENABLE_WAYLAND=1
      # force firefox to use remote backend so apps running in xwayland
      # open links in the wayland instance.
      export MOZ_DBUS_REMOTE=1

      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1

      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP=sway

      # Shouldn't be needed since it is in /etc/gtk-3.0/settings.ini
      export GTK_THEME=Adwaita-dark

      systemctl --user import-environment
    '';

    extraPackages = with pkgs; [
      firefox
      grim
      kanshi
      kitty
      slurp
      swayidle
      swaylock
      wl-clipboard
      wlsunset
      xwayland
    ];
  };

  xdg.portal = {
    enable = mkDefault true;
    extraPortals = with pkgs; [
      # required to get gtk apps to find the correct theme
      xdg-desktop-portal-gtk
    ];

    wlr = {
      enable = mkDefault true;
      #settings.screencast =
      #  let
      #    clear = "00000000";
      #    selected = "${config.hole.colors.gruvbox.dark-no-hash.aqua0}7f";
      #    cmd = concatStringsSep " " [
      #      "${pkgs.slurp}/bin/slurp -or"
      #      "-f %o"
      #      "-B ${clear}"
      #      "-b ${clear}"
      #      "-s ${selected}"
      #      "-w 0"
      #    ];
      #  in
      #  {
      #    chooser_type = mkDefault "simple";
      #    chooser_cmd = mkDefault cmd;
      #  };
    };
  };
}
