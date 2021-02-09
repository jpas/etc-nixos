final: prev:
let
  callPackage = prev.lib.callPackageWith prev;
in rec {
  volatile = import <nixos-volatile> {
    config = final.config;
  };

  scholar = callPackage ./pkgs/scholar { };
  srvfb = callPackage ./pkgs/srvfb { };

  gnomeExtensions = prev.gnomeExtensions // {
    pop-shell = callPackage ./pkgs/pop-shell { };
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
}
