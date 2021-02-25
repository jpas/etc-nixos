{ pkgs ? import <nixpkgs> }:
let inherit (pkgs) callPackage;
in rec {
  volatile = import <nixos-volatile> { inherit (pkgs) config; };

  scholar = callPackage ./scholar { };
  srvfb = callPackage ./srvfb { };

  wdomirror = callPackage ./wdomirror { };

  intel-undervolt = callPackage ./intel-undervolt { };

  ddccontrol-db = pkgs.ddccontrol-db.overrideAttrs (old: rec {
    name = "ddccontrol-db-${version}";
    version = "20201221";

    src = pkgs.fetchFromGitHub {
      owner = "ddccontrol";
      repo = "ddccontrol-db";
      rev = version;
      sha256 = "1sryyjjad835mwc7a2avbij6myln8b824kjdr78gc9hh3p16929b";
    };
  });
}
