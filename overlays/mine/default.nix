final: prev:
let callPackage = prev.lib.callPackageWith prev;
in rec {
  volatile = import <nixos-volatile> { config = final.config; };

  scholar = callPackage ./pkgs/scholar { };
  srvfb = callPackage ./pkgs/srvfb { };

  wdomirror = callPackage ./pkgs/wdomirror { };

  gnomeExtensions = prev.gnomeExtensions // {
    pop-shell = volatile.gnomeExtensions.pop-os-shell;
  };

  intel-undervolt = callPackage ./pkgs/intel-undervolt { };

  ddccontrol-db = prev.ddccontrol-db.overrideAttrs (old: rec {
    version = "20201221";
    name = "ddccontrol-db-${version}";

    src = prev.fetchFromGitHub {
      owner = "ddccontrol";
      repo = "ddccontrol-db";
      rev = version;
      sha256 = "1sryyjjad835mwc7a2avbij6myln8b824kjdr78gc9hh3p16929b";
    };
  });

  haskellPackages = prev.haskellPackages.override {
    overrides = (n: o: {
      lol = o.lol.overrideAttrs (_: {
        src = /home/jpas/people/nate/lol/Lol/lol;
        meta.broken = false;
      });

      lol-apps = o.lol-apps.overrideAttrs (_: {
        src = /home/jpas/people/nate/lol/Lol/lol-apps;
        meta.broken = false;
      });

      lol-cpp = o.lol-cpp.overrideAttrs (_: {
        src = /home/jpas/people/nate/lol/Lol/lol-cpp;
        meta.broken = false;
      });
    });
  };
}
