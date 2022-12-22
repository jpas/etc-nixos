final: prev:
let
  inherit (prev) lib callPackage;

  patchPackage = pkg: patches: pkg.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ patches;
  });

  hole = rec {
    authelia = callPackage ./authelia { };
    ftpserver = callPackage ./ftpserver { };
    gamescope = callPackage ./gamescope { };
    gammactl = callPackage ./gammactl { };
    lemurs = callPackage ./lemurs { };
    lldap = callPackage ./lldap { };
    oauth2ms = callPackage ./oauth2ms { };
    oauth2token = callPackage ./oauth2token { };
    wl-gammarelay-rs = callPackage ./wl-gammarelay-rs { };

    direnv = patchPackage prev.direnv [
      (final.fetchpatch {
        # supports searching XDG_CONFIG_DIRS for direnv/lib/*.sh
        # see: https://github.com/direnv/direnv/pull/990
        url = "https://github.com/direnv/direnv/commit/ce1c286eac16e4f5541b3af1231783667bc45cae.patch";
        hash = "sha256-9FwuucyhhFW+uO2oO4kavThig9Y702YJnUUhIFeDDIk=";
      })
    ];
    mako = patchPackage prev.mako [ ./patches/mako-check-etc-xdg.patch ];
    swayidle = patchPackage prev.swayidle [ ./patches/swayidle-check-etc-xdg.patch ];
    swaylock = patchPackage prev.swaylock [ ./patches/swaylock-check-etc-xdg.patch ];
    tofi = patchPackage prev.tofi [ ./patches/tofi-check-etc-xdg.patch ];

    kanidm = prev.kanidm.overrideAttrs (o: rec {
      name = "${o.pname}-${version}";
      version = "1.1.0-alpha.10";
      src = prev.fetchFromGitHub {
        owner = o.pname;
        repo = o.pname;
        rev = "v${version}";
        hash = "sha256-ICS7nwgFGbTiobr8Sw/ZHO6jBUfiq8KyE/MiLg8uDUA=";
      };

      cargoPatches = (o.cargoPatches or [ ]) ++ [
        (final.fetchpatch {
          # fixes test_password_from_ipa_nt_hash and test_password_from_samba_nt_hash
          url = "https://github.com/kanidm/kanidm/commit/546f1c8da7c651aa38c1b627dce58e0acc3b1510.patch";
          hash = "sha256-c39XzWifgenli0UfSdijQzaVOpednKD9G1iJE37D4xg=";
        })
      ];

      patches = (o.patches or [ ]) ++ cargoPatches;

      cargoDeps = o.cargoDeps.overrideAttrs (o: {
        inherit src;
        name = "${name}-vendor.tar.gz";
        outputHash = "sha256-/CcmKYPtBHNdhJnO0OmZtW/39HH58qmCE9hFbIiNsaE=";
        patches = cargoPatches;
      });
    });

    go-chromecast = prev.go-chromecast.overrideAttrs (o: {
      doCheck = false;
      meta = o.meta // {
        broken = false;
      };
    });
  };
in
hole // { inherit hole; }
