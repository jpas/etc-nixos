{ lib, pkgs, ... }:

with lib;

{
  programs.firefox.enable = true;
  programs.firefox.autoConfig = ''
    lockPref("extensions.pocket.enabled", false)
    lockPref("signon.rememberSignons", false)
    lockPref("pref.general.disable_button.default_browser", true)
    lockPref("pref.privacy.disable_button.view_passwords", true)
  '';

  programs.sway.extraSessionCommands = ''
    export MOZ_ENABLE_WAYLAND=1
    # open links using the wayland instance when possible
    export MOZ_DBUS_REMOTE=1
  '';

  programs.sway.include."50-firefox.conf" = ''
    no_focus [title="Firefox — Sharing Indicator"]
    for_window [title="Firefox — Sharing Indicator"] {
      border none
      floating enable
      move position 50% 20
      sticky enable
    }
  '';
}
