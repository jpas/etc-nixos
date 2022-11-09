final: prev:
let
  inherit (prev) lib callPackage;

  hole = rec {
    ftpserver = callPackage ./ftpserver { };
    gamescope = callPackage ./gamescope { };
    oauth2ms = callPackage ./oauth2ms { };
    oauth2token = callPackage ./oauth2token { };
  };
in
hole // { inherit hole; }
