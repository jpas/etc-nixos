{ lib, ... }:
{
  disabledModules = [ "programs/neovim.nix" ];
  options = {
    programs.neovim.enable = mkEnableOption "neovim";
  };
}
