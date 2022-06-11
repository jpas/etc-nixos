{ config, lib, ... }:

let

  cfg = config.hole.security;

in

{
  options = {
    hole.security.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable security config.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.editor = false;
  };
}
