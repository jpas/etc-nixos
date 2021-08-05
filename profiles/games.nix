{ lib
, config
, pkgs
, ...
}:

with lib;

{
  config = mkIf (config.hole.profiles ? games) {
    systemd.tmpfiles.rules = [
      "d /opt       0755 root root - -"
      "d /opt/games 0775 root users - -"
      "Z /opt/games -    root users - -"
      "A /opt/games -    -    -     - default:mask::rwx"
    ];
  };
}
