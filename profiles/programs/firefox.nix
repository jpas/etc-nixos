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

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "google@search.mozilla.org".installation_mode = "blocked";
        "wikipedia@search.mozilla.org".installation_mode = "blocked";
        "bing@search.mozilla.org".installation_mode = "blocked";
        "amazon@search.mozilla.org".installation_mode = "blocked";
        "ebay@search.mozilla.org".installation_mode = "blocked";
      };

      #Extensions = {
      #  Uninstall = [
      #    "google@search.mozilla.org"
      #    "wikipedia@search.mozilla.org"
      #    "bing@search.mozilla.org"
      #    "amazon@search.mozilla.org"
      #    "ebay@search.mozilla.org"
      #  ];
      #};
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
