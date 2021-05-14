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

    #hole.colors = mkOption {
    #  type = types.attrsOf types.str;
    #  default = {
    #  };
    #};
  };
}
