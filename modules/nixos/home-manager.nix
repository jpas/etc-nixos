{ config, ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/master.tar.gz";
  };
in {
  imports = [ "${home-manager}/nixos" ];

  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
