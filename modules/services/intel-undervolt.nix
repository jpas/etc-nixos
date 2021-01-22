{ lib, config, pkgs, ... }:

with lib;

let

  cfg = config.services.intel-undervolt;

in {
  options = {
    services.intel-undervolt = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable undervolting for Haswell and newer Intel CPUs.
        '';
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Alternative configuration";
      };
    };
  };

  config = mkIf (cfg.enable) {
    systemd.packages = [ pkgs.intel-undervolt ];
    systemd.services.intel-undervolt.wantedBy = [ "multi-user.target" ];

    environment.etc."intel-undervolt.conf" = mkIf (cfg.extraConfig != "") {
      source = pkgs.writeText "intel-undervolt.conf" cfg.extraConfig;
    };
  };
}
