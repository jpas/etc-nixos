{ lib, config, ... }:

with lib;

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/master.tar.gz";
  };
in {
  imports = [ "${home-manager}/nixos" ];

  options = {
    home-manager.imports = mkOption {
      type = types.listOf types.unspecified;
      default = [ ];
    };
  };

  config = {
    home-manager.backupFileExtension = "backup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.imports = [
      (import ../home/all-modules.nix)
    ];
  };
}
