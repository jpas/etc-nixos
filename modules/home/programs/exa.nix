{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.programs.exa;
in
{
  options = {
    programs.exa = {
      enable = mkEnableOption "exa, a modern replacement for ls";

      lsAlias = mkEnableOption "alias ls to exa";

      package = mkOption {
        type = types.package;
        default = pkgs.exa;
        defaultText = literalExample "pkgs.exa";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.bash.shellAliases = mkIf cfg.lsAlias { ls = "exa"; };
    programs.fish.shellAliases = mkIf cfg.lsAlias { ls = "exa"; };
    programs.zsh.shellAliases = mkIf cfg.lsAlias { ls = "exa"; };
  };
}
