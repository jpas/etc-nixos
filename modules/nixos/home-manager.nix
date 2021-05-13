{ lib
, config
, ...
}:

with lib;

{
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
    home-manager.imports = [ (import ../home-manager) ];
  };
}
