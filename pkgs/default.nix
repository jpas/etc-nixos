{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) callPackage;
in
rec {
  volatile = import <nixos-volatile> { inherit (pkgs) config; };

  kanshi = pkgs.kanshi.overrideAttrs (old: rec {
    version = "2021-02-02-unstable";
    src = pkgs.fetchFromGitHub {
      owner = "emersion";
      repo = "kanshi";
      rev = "dabd7a29174a74b3f21a2b4cc3d9dc63221761bb";
      hash = "sha256-FGEYfl6BSSK9RbGEIoynv1tzkFFn0kafxr5Jux/moP0=";
    };
  });

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
