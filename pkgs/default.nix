{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) callPackage;
in
rec {
  volatile = import <nixos-volatile> { inherit (pkgs) config; };

  steam = pkgs.steam.override {
    nativeOnly = true;
  };

  ftpserver = callPackage ./ftpserver { };

  oauth2ms = callPackage ./oauth2ms { };

  scholar = callPackage ./scholar { };

  srvfb = callPackage ./srvfb { };

  xplr = callPackage ./xplr { };

  yofi = callPackage ./yofi { };

  libliftoff = callPackage ./libliftoff { };

  gamescope = callPackage ./gamescope { inherit libliftoff; };

  davmail = pkgs.davmail.overrideAttrs (old: rec {
    version = "5.5.1";
    src = pkgs.fetchurl {
      url = "mirror://sourceforge/${old.pname}/${version}/${old.pname}-${version}-3299.zip";
      hash = "sha256-NN/TUOcUIifNzrJnZmtYhs6UVktjlfoOYJjYaMEQpI4=";
    };
  });
}
