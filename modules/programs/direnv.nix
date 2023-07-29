{ lib, config, pkgs, ... }:

with lib;

{}

/*
let
  cfg = config.programs.direnv;
in
{
  options = {
    programs.direnv.enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.direnv ];

    programs.bash.interactiveShellInit = mkAfter ''
      eval "$(direnv hook bash)"
    '';

    programs.zsh.interactiveShellInit = mkAfter ''
      eval "$(direnv hook zsh)"
    '';

    programs.fish.interactiveShellInit = mkAfter ''
      direnv hook fish | source
    '';

    environment.etc."xdg/direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";

    nix.settings.keep-outputs = true;
    nix.settings.keep-derivations = true;
  };
}
*/
