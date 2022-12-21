{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.sway;

  includeFiles = flip mapAttrs' cfg.include (name: text: {
    name = "sway/config.d/${name}";
    value.source = pkgs.writeText "${name}" text;
  });
in
{
  options.programs.sway = {
    settings = mkOption {
      type = types.lines;
      default = ''
        include /etc/sway/config.d/*.conf
      '';
    };

    include = mkOption {
      type = with types; attrsOf lines;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    environment.etc = includeFiles // {
      "sway/config".text = cfg.settings;
    };
  };
}
