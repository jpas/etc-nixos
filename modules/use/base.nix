{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hole.use;

in

{
  options = {
    hole.use = {
      base = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable base config.";
      };
      minimal = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable minimal config.";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.base { })

    (mkIf (!cfg.minimal && cfg.base) { })
  ];
}
