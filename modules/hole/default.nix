{ lib
, config
, ...
}:

with lib;

{
  imports = [
    ./colors.nix
  ];

  options = {
    hole.profiles = mkOption {
      type = types.attrsOf types.bool;
      default = { };
    };
  };
}
