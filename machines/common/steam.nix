{ lib
, config
, ...
}:

with lib;

let
  cfg = config.programs.steam;
in
{
  users.groups.steam = {
    members = [ "jpas" "kbell" ];
  };
  systemd.tmpfiles.rules = [
    "d /opt       0755 root root - -"
    "d /opt/steam 0775 root root - -"
    "A /opt/steam -    -    -    - default:group:steam:rwx"
  ];
}

