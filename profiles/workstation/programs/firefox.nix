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
}
