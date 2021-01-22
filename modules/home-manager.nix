{ ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/master.tar.gz";
  };
in {
  imports = [ "${home-manager}/nixos" ];
  home-manager.useGlobalPkgs = true;
}
