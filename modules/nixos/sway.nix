{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.sway;

  configFile =
    if cfg.config == null
    then { }
    else { "sway/config".source = pkgs.writeText "config" cfg.config; };

  includeFiles = flip mapAttrs' cfg.include (name: text: {
    name = "sway/config.d/${name}";
    value.source = pkgs.writeText "${name}" text;
  });
in
{
  options.programs.sway = {
    config = mkOption {
      type = with types; nullOr lines;
      default = null;
    };

    include = mkOption {
      type = with types; attrsOf lines;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    environment.etc = includeFiles // configFile;
  };
}
