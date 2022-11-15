{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.programs.direnv;
in
{
  options = {
    direnv.enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    programs.bash.interactiveShellInit = ''
      eval "$(direnv hook bash)"
    '';

    programs.zsh.interactiveShellInit = ''
      eval "$(direnv hook zsh)"
    '';

    programs.fish.interactiveShellInit = ''
      direnv hook fish | source
    '';

    environment.etc."xdg/direnv/lib/nix-direnv.sh".link = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";

    nix.settings.keep-outputs = true;
    nix.settings.keep-derivations = true;
  };
}
