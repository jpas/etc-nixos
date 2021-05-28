final: prev:
let
  inherit (prev) lib;
  overlays = lib.attrValues (builtins.getFlake "hole").overlays;
in
  lib.foldl' (lib.flip lib.extends) (_: prev) overlays final
