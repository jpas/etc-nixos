final: prev:
let
  inherit (prev) lib callPackage;

  hole = rec {
    ftpserver = callPackage ./ftpserver { };
    gamescope = callPackage ./gamescope { };
    oauth2ms = callPackage ./oauth2ms { };
    oauth2token = callPackage ./oauth2token { };

    direnv = prev.direnv.overrideAttrs (o: {
      patches = (o.patches or []) ++ [
        # supports searching XDG_CONFIG_DIRS for direnv/lib/*.sh
        # see: https://github.com/direnv/direnv/pull/990
        (final.fetchpatch {
          url = "https://github.com/direnv/direnv/commit/ce1c286eac16e4f5541b3af1231783667bc45cae.patch";
          hash = "sha256-9FwuucyhhFW+uO2oO4kavThig9Y702YJnUUhIFeDDIk=";
        })
      ];
    });
  };
in
hole // { inherit hole; }
