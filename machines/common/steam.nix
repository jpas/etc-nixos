{ lib
, config
, ...
}:

with lib;

let
  cfg = config.programs.steam;
in
mkIf cfg.enable {
  systemd.tmpfiles.rules = [
    "d /opt       0755 root root - -"
    "d /opt/games 0755 root root - -"
    "A /opt/games -    -    -    - group:users:rwx"
    "A /opt/games -    -    -    - default:group:users:rwx"
    "Z /opt/games 0755 root root - -"
  ];
}

