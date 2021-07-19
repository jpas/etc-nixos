{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.hole.aleph;
in
{
  options = {
    hole.aleph = {
      enable = mkEnableOption "mount aleph";
      hostname = mkOption {
        description = "hostname that aleph lives on";
        type = types.str;
        default = "kado.o";
      };
    };
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    fileSystems."/aleph" = {
      device = "${cfg.hostname}:/aleph";
      fsType = "nfs4";
      options = [
        "noatime"
        "nodiratime"
        "x-systemd.automount"
        "x-systemd.idle-timeout=10m"
        "x-systemd.requires=tailscale-peer@${cfg.hostname}.service"
      ];
      noCheck = true;
    };
  };
}
