{ lib, pkgs, ... }:

with lib;

{
  environment.systemPackages = [ pkgs.firefox ];

  programs.sway.extraSessionCommands = ''
    export MOZ_ENABLE_WAYLAND=1
    # open links using the wayland instance when possible
    export MOZ_DBUS_REMOTE=1
  '';
}
