{ lib
, config
, ...
}:

with lib;

let

  cfg = config.programs.bat;

in
{
  options = { programs.bat.catAlias = mkEnableOption "Alias cat to bat"; };

  config = mkIf cfg.catAlias {
    programs.bash.shellAliases = { cat = "bat"; };
    programs.fish.shellAliases = { cat = "bat"; };
    programs.zsh.shellAliases = { cat = "bat"; };
  };
}
