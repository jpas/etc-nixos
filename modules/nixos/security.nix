{ lib
, config
}:

let
  cfg = config.hole.security;
in
{
  options.hole.security.enable = mkOption {
    description = "Whether to enable security config.";
    default = true;
    type = types.bool;
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.editor = mkDefault false;
  };
}
