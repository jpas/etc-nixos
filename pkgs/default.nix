{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) callPackage;
in
rec {
  ftpserver = callPackage ./ftpserver { };
  gamescope = callPackage ./gamescope { inherit libliftoff; };
  libliftoff = callPackage ./libliftoff { };
  oauth2ms = callPackage ./oauth2ms { };
  scholar = callPackage ./scholar { };
  srvfb = callPackage ./srvfb { };
  xplr = callPackage ./xplr { };
  yofi = callPackage ./yofi { };

  kanshi = pkgs.kanshi.overrideAttrs (_: {
    version = "2021-02-02-unstable";
    src = pkgs.fetchFromGitHub {
      owner = "emersion";
      repo = "kanshi";
      rev = "dabd7a29174a74b3f21a2b4cc3d9dc63221761bb";
      hash = "sha256-FGEYfl6BSSK9RbGEIoynv1tzkFFn0kafxr5Jux/moP0=";
    };
  });
}
