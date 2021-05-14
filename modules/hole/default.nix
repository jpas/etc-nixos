{ lib
, ...
}:

with lib;

{
  options = {
    hole.profiles = mkOption {
      type = types.attrsOf types.bool;
      default = { };
    };
  };

  config = { };
}
