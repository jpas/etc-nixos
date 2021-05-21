{ lib
, config
, ...
}:

with lib;

let
  cfg = config.programs.steam;
in
{
  systemd.tmpfiles.rules = [
    "d /opt       0755 root root - -"
    "d /opt/steam 0755 root root - -"
    "A /opt/steam -    -    -    - group:users:rwx"
    "A /opt/steam -    -    -    - default:users:steam:rwx"
  ];
}

