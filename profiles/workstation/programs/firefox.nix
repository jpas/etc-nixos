{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.firefox;
in
{
  programs.firefox.enable = true;
  programs.firefox = {
    policies = {
      DisablePocket = true;
      DisableProfileRefresh = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      SearchEngines = {
        Default = "DuckDuckGo";
        Remove = [
          "Google"
          "Amazon.ca"
          "Bing"
          "eBay"
          "Wikipedia (en)"
        ];
      };
    };
  };

  programs.sway = mkIf cfg.enable {
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      # open links using the wayland instance when possible
      export MOZ_DBUS_REMOTE=1
    '';

    include."50-firefox.conf" = ''
      no_focus [title="Firefox — Sharing Indicator"]
      for_window [title="Firefox — Sharing Indicator"] {
        border none
        floating enable
        move position 50% 20
        sticky enable
      }
    '';
  };
}
